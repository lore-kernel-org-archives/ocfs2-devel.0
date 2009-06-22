From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 22 Jun 2009 11:40:06 -0700
Subject: [Ocfs2-devel] Orphan Scan - v3
Message-ID: <1245696007-29494-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch 5 has been respun with the recommended change... remove the ex
argument in ocfs2_orphan_scan_lock() and ocfs2_orphan_scan_unlock().

Sunil
