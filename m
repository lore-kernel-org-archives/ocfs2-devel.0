From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 28 Jan 2015 14:12:08 -0800
Subject: [Ocfs2-devel] [PATCH 6/6] Add users guide (txt version) and o2cb
	README to DIST_FILES so they are included in the tarball
	output of 'make dist'.
In-Reply-To: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
References: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
Message-ID: <1422483128-32471-7-git-send-email-mfasheh@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 5bd380b..9519a4e 100644
--- a/Makefile
+++ b/Makefile
@@ -57,6 +57,7 @@ DIST_FILES = \
 	CREDITS					\
 	MAINTAINERS				\
 	README					\
+	README.O2CB				\
 	Config.make.in				\
 	Preamble.make				\
 	Postamble.make				\
@@ -79,6 +80,7 @@ DIST_FILES = \
 	vendor.guess				\
 	Makepdfs				\
 	documentation/samples/cluster.conf	\
+	documentation/users_guide.txt		\
 	$(PKGCONFIG_SOURCES)			\
 	$(DEBIAN_FILES)
 
-- 
2.1.2
