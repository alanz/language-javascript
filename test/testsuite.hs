
import Control.Monad (when)
import System.Exit
import Test.Hspec
import Test.Hspec.Runner


import Test.Language.Javascript.ExpressionParser
import Test.Language.Javascript.Lexer
import Test.Language.Javascript.LiteralParser
import Test.Language.Javascript.Minify
import Test.Language.Javascript.ProgramParser
import Test.Language.Javascript.RoundTrip
import Test.Language.Javascript.StatementParser


main :: IO ()
main = do
    summary <- hspecWithResult defaultConfig testAll
    when (summaryFailures summary == 0)
        exitSuccess
    exitFailure


testAll :: Spec
testAll = do
    testLexer
    testLiteralParser
    testExpressionParser
    testStatementParser
    testProgramParser
    testRoundTrip
    testMinifyExpr
    testMinifyStmt
    testMinifyProg
