
import Test.Framework (defaultMain, testGroup, Test)
import Test.Framework.Providers.HUnit
import Test.HUnit hiding (Test)


import Language.JavaScript.Parser.Parser
import Language.JavaScript.Parser.Grammar

main :: IO ()
main = defaultMain [testSuite]

testSuite :: Test
testSuite = testGroup "Parser"
    [ 
      testCase "helloWorld"        caseHelloWorld  
    , testCase "LiteralNull"       (testLiteral "null"     "Right (JSLiteral \"null\")")
    , testCase "LiteralFalse"      (testLiteral "false"    "Right (JSLiteral \"false\")")
    , testCase "LiteralTrue"       (testLiteral "true"     "Right (JSLiteral \"true\")")
    , testCase "LiteralHexInteger" (testLiteral "0x1234fF" "Right (JSHexInteger \"0x1234fF\")")
    , testCase "LiteralDecimal1"   (testLiteral "1.0e4"    "Right (JSDecimal \"1.0e4\")")
    , testCase "LiteralDecimal2"   (testLiteral "2.3E6"    "Right (JSDecimal \"2.3E6\")")
    , testCase "LiteralDecimal3"   (testLiteral "4.5"      "Right (JSDecimal \"4.5\")")
    , testCase "LiteralDecimal3"   (testLiteral "0.7e8"    "Right (JSDecimal \"0.7e8\")")
    , testCase "LiteralDecimal4"   (testLiteral "0.7E8"    "Right (JSDecimal \"0.7E8\")")
    , testCase "LiteralDecimal5"   (testLiteral "10"       "Right (JSDecimal \"10\")")
    , testCase "LiteralDecimal6"   (testLiteral "0"        "Right (JSDecimal \"0\")")
    , testCase "LiteralDecimaly"   (testLiteral "0.03"     "Right (JSDecimal \"0.03\")")
      
    , testCase "LiteralString1"    (testLiteral "\"hello\\nworld\"" "Right (JSStringLiteral '\"' \"hello\\\\nworld\")")  
    , testCase "LiteralString2"    (testLiteral "'hello\\nworld'"  "Right (JSStringLiteral '\\'' \"hello\\\\nworld\")")
      
    , testCase "LiteralThis"       (testPE "this"  "Right (JSLiteral \"this\")")
      
    , testCase "LiteralRegex1"     (testPE "/blah/"  "Right (JSRegEx \"/blah/\")")
    , testCase "LiteralRegex2"     (testPE "/$/g"    "Right (JSRegEx \"/$/g\")")
      
    , testCase "Identifier1"       (testPE "_$"      "Right (JSIdentifier \"_$\")")
    , testCase "Identifier2"       (testPE "this_"   "Right (JSIdentifier \"this_\")")
      
    , testCase "ArrayLiteral1"     (testPE "[]"      "Right (JSArrayLiteral [])")
    , testCase "ArrayLiteral2"     (testPE "[,]"     "Right (JSArrayLiteral [JSElision []])")
    , testCase "ArrayLiteral3"     (testPE "[,,]"    "Right (JSArrayLiteral [JSElision [],JSElision []])")
      
    , testCase "Statement1"        (testStmt "x"    "Right (JSIdentifier \"x\")")
    , testCase "Statement2"        (testStmt "null" "Right (JSLiteral \"null\")")

    ]

srcHelloWorld = "Hello"
caseHelloWorld =  
  "Right (JSIdentifier \"Hello\")"
  @=? (show $ parseStmt srcHelloWorld "src")
  

-- ---------------------------------------------------------------------
-- Test utilities

testLiteral literal expected = expected @=? (show $ parseUsing parseLiteral literal "src")

testPE str expected = expected @=? (show $ parseUsing parsePrimaryExpression str "src")

testStmt str expected = expected @=? (show $ parseUsing parseStatement str "src")


-- EOF
