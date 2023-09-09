{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_haskQuery (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/david/Desktop/HNG-X/TaskOne/haskQuery/.stack-work/install/x86_64-linux-tinfo6/c75c6faaaccecff3d94d1ea5a9ae1098b08553cc2b0fe4a5beb1b9a910b0daa8/9.4.6/bin"
libdir     = "/home/david/Desktop/HNG-X/TaskOne/haskQuery/.stack-work/install/x86_64-linux-tinfo6/c75c6faaaccecff3d94d1ea5a9ae1098b08553cc2b0fe4a5beb1b9a910b0daa8/9.4.6/lib/x86_64-linux-ghc-9.4.6/haskQuery-0.1.0.0-GHIHSapJjWP3ZEiunkJvFq-haskQuery-exe"
dynlibdir  = "/home/david/Desktop/HNG-X/TaskOne/haskQuery/.stack-work/install/x86_64-linux-tinfo6/c75c6faaaccecff3d94d1ea5a9ae1098b08553cc2b0fe4a5beb1b9a910b0daa8/9.4.6/lib/x86_64-linux-ghc-9.4.6"
datadir    = "/home/david/Desktop/HNG-X/TaskOne/haskQuery/.stack-work/install/x86_64-linux-tinfo6/c75c6faaaccecff3d94d1ea5a9ae1098b08553cc2b0fe4a5beb1b9a910b0daa8/9.4.6/share/x86_64-linux-ghc-9.4.6/haskQuery-0.1.0.0"
libexecdir = "/home/david/Desktop/HNG-X/TaskOne/haskQuery/.stack-work/install/x86_64-linux-tinfo6/c75c6faaaccecff3d94d1ea5a9ae1098b08553cc2b0fe4a5beb1b9a910b0daa8/9.4.6/libexec/x86_64-linux-ghc-9.4.6/haskQuery-0.1.0.0"
sysconfdir = "/home/david/Desktop/HNG-X/TaskOne/haskQuery/.stack-work/install/x86_64-linux-tinfo6/c75c6faaaccecff3d94d1ea5a9ae1098b08553cc2b0fe4a5beb1b9a910b0daa8/9.4.6/etc"

getBinDir     = catchIO (getEnv "haskQuery_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "haskQuery_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "haskQuery_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "haskQuery_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "haskQuery_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "haskQuery_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
