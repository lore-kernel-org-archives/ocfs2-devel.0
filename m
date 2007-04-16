From: Jeff Mahoney <jeffm@suse.com>
Date: Mon Apr 16 10:57:16 2007
Subject: [Ocfs2-devel] [PATCH] fix up sles9 spec file
Message-ID: <4623B8E3.4090002@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


This patch teaches the sles9 spec file to understand that configfs
is built conditionally, and may not be present in the output.

- -Jeff

diff -ruNp ocfs2-1.2.5/vendor/sles9/ocfs2.spec-generic.in ocfs2-1.2.5.devel/vendor/sles9/ocfs2.spec-generic.in
- --- ocfs2-1.2.5/vendor/sles9/ocfs2.spec-generic.in	2007-03-27 15:54:15.000000000 -0400
+++ ocfs2-1.2.5.devel/vendor/sles9/ocfs2.spec-generic.in	2007-04-16 13:05:25.962229912 -0400
@@ -301,9 +301,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif
@@ -324,9 +326,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif
@@ -347,9 +351,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif
@@ -370,9 +376,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif
@@ -393,9 +401,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif
@@ -416,9 +426,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif
@@ -439,9 +451,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif
@@ -462,9 +476,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif
@@ -485,9 +501,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif
@@ -508,9 +526,11 @@ mv "${EXTRA_MODLIB}"/ocfs2_nodemanager.k
 mkdir -p "${INST_MODLIB}/fs/ocfs2/dlm"
 mv "${EXTRA_MODLIB}"/ocfs2_dlm.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
 mv "${EXTRA_MODLIB}"/ocfs2_dlmfs.ko "${INST_MODLIB}/fs/ocfs2/dlm/"
- -mkdir -p "${INST_MODLIB}/fs/configfs"
- -mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
- -rm "${EXTRA_MODLIB}"/*.ko
+if [ -e "${EXTRA_MODLIB}/configfs.ko" ]; then
+	mkdir -p "${INST_MODLIB}/fs/configfs"
+	mv "${EXTRA_MODLIB}"/configfs.ko "${INST_MODLIB}/fs/configfs/"
+fi
+rm -f "${EXTRA_MODLIB}"/*.ko
 
 make clean
 %endif

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGI7jjLPWxlyuTD7IRArXSAJ46nvnYc57oaIqyavc3P02Q+U0duwCfSEU9
fSRooxqW35a9LTX6EJAg3qw=
=CyVk
-----END PGP SIGNATURE-----
