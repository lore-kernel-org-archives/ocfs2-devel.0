From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  4 May 2009 16:10:32 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Up version to 1.4.2
In-Reply-To: <1241478632-16369-1-git-send-email-sunil.mushran@oracle.com>
References: <1241478632-16369-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1241478632-16369-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Up version to 1.4.2. Also increase the required tools version to 1.4.2
as it includes some fixes for inline data.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 configure.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index b7efa1b..34d6e74 100644
--- a/configure.in
+++ b/configure.in
@@ -9,11 +9,11 @@ AC_SUBST(PACKAGE)
 # Adjust these for the software version.
 MAJOR_VERSION=1
 MINOR_VERSION=4
-MICRO_VERSION=1
+MICRO_VERSION=2
 EXTRA_VERSION=
 
 # Required version of ocfs-tools
-TOOLS_REQUIRED_VERSION=1.4.1
+TOOLS_REQUIRED_VERSION=1.4.2
 
 DIST_VERSION=$MAJOR_VERSION.$MINOR_VERSION.$MICRO_VERSION
 if test -z "$EXTRA_VERSION"; then
-- 
1.5.6.3
