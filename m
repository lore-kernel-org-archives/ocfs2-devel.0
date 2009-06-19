From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 19 Jun 2009 16:53:16 -0700
Subject: [Ocfs2-devel] Orphan scan fixes - V2
Message-ID: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Implemented the suggestions.

Also, moved the ocfs2_orphan_scan_init() to the end of ocfs2_fill_super()
instead of calling it earlier in ocfs2_initialize_super().

Sunil
