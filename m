From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Dec 2008 14:17:41 -0800
Subject: [Ocfs2-devel] Patches for next merge window - 2
Message-ID: <1229552263-23741-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Resending two debugfs patches that now make use of generic_file_llseek()
instead of the hand-rolled _llseek().
