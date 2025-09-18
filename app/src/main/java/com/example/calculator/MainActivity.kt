package com.example.calculator

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.TextView
import java.lang.ArithmeticException

class MainActivity : AppCompatActivity() {

    private lateinit var resultTextView: TextView

    private var lastNumeric: Boolean = false
    private var lastDot: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        resultTextView = findViewById(R.id.resultTextView)
    }

    fun onDigit(view: View) {
        resultTextView.append((view as Button).text)
        lastNumeric = true
    }

    fun onClear(view: View) {
        resultTextView.text = ""
        lastNumeric = false
        lastDot = false
    }

    fun onDecimalPoint(view: View) {
        if (lastNumeric && !lastDot) {
            resultTextView.append(".")
            lastNumeric = true // Still a numeric entry
            lastDot = true
        }
    }

    fun onOperator(view: View) {
        if (lastNumeric) {
            resultTextView.append((view as Button).text)
            lastNumeric = false
            lastDot = false // Reset for next number
        }
    }

    fun onEqual(view: View) {
        if (lastNumeric) {
            var expression = resultTextView.text.toString()
            try {
                val result = evaluateExpression(expression)
                resultTextView.text = removeZeroAfterDot(result.toString())
                lastDot = resultTextView.text.contains('.')
            } catch (e: Exception) {
                resultTextView.text = "Error"
                lastNumeric = false
                lastDot = false
            }
        }
    }

    private fun evaluateExpression(expression: String): Double {
        // A simple parser to handle order of operations (PEMDAS/BODMAS)
        // 1. Tokenize the string
        val tokens = mutableListOf<Any>()
        val numberBuilder = StringBuilder()

        for (char in expression) {
            if (char.isDigit() || char == '.') {
                numberBuilder.append(char)
            } else {
                if (numberBuilder.isNotEmpty()) {
                    tokens.add(numberBuilder.toString().toDouble())
                    numberBuilder.clear()
                }
                // Handle negative numbers at the start or after an operator
                if (char == '-' && (tokens.isEmpty() || tokens.last() is Char)) {
                     numberBuilder.append(char)
                } else {
                    tokens.add(char)
                }
            }
        }
        if (numberBuilder.isNotEmpty()) {
            tokens.add(numberBuilder.toString().toDouble())
        }

        // 2. Perform multiplication and division
        val newTokens = mutableListOf<Any>()
        var i = 0
        while (i < tokens.size) {
            if (tokens[i] is Char && (tokens[i] as Char == '×' || tokens[i] as Char == '÷')) {
                val left = newTokens.removeAt(newTokens.lastIndex) as Double
                val right = tokens[i + 1] as Double
                val result = if (tokens[i] as Char == '×') {
                    left * right
                } else {
                    if (right == 0.0) throw ArithmeticException("Division by zero")
                    left / right
                }
                newTokens.add(result)
                i += 2
            } else {
                newTokens.add(tokens[i])
                i++
            }
        }

        // 3. Perform addition and subtraction
        var result = newTokens[0] as Double
        i = 1
        while (i < newTokens.size) {
            val operator = newTokens[i] as Char
            val right = newTokens[i + 1] as Double
            result = if (operator == '+') result + right else result - right
            i += 2
        }
        return result
    }

    fun onBackspace(view: View) {
        val text = resultTextView.text.toString()
        if (text.isNotEmpty()) {
            resultTextView.text = text.substring(0, text.length - 1)
            val newText = resultTextView.text
            if (newText.isEmpty()) {
                lastNumeric = false
                lastDot = false
            } else {
                val lastChar = newText.last()
                lastNumeric = lastChar.isDigit()

                // Check if the current number segment has a dot
                val lastOperatorIndex = newText.indexOfLast { it in "+-×÷" }
                val currentSegment = if (lastOperatorIndex != -1) {
                    newText.substring(lastOperatorIndex + 1)
                } else {
                    newText
                }
                lastDot = currentSegment.contains('.')
            }
        }
    }

    private fun removeZeroAfterDot(result: String): String {
        if (result.endsWith(".0")) {
            return result.substring(0, result.length - 2)
        }
        return result
    }
}
