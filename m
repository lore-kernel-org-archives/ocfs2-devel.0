From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Fri Feb 27 18:09:59 2004
Subject: [Ocfs2-devel] Makefile and configure changes for 2.6 support
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A56965@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> This is a cumulative patch to provide support to the build 
> system for building OCFS2 for 2.6.
> 
> This does NOT have the patches that are needed to the source 
> code files to make them build under 2.6.
> 
> It only consists of changes to:
> Config.make.in
> configure.in
> src/Makefile
> 
> and the addition of:
> src/Makefile-2.6.in
> 


Just one note.  If you are using a version of AutoConf before 2.58 then
you will need to do:

s/AS_HELP_STRING/AC_HELP_STRING/

Version 2.58 of AutoConf obsoleted AC_HELP_STRING and renamed it to
AS_HELP_STRING.

John
