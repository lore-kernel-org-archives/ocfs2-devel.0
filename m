From: Jan Kara <jack@suse.cz>
Date: Mon, 12 Jan 2009 23:20:28 +0100
Subject: [Ocfs2-devel] [PATCH 0/5] OCFS2 quota fixes
In-Reply-To: <y>
References: <y>
Message-ID: <1231798833-6850-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

the following series of patches fixes some issues with OCFS2 quotas.
The first patch modifies VFS quota locking, the next patch uses the
fact to simplify OCFS2 quota locking and solves a few deadlock issues.
The third and the fourth patches fix another possible deadlocks in OCFS2
quota code and the last patch is a minor cleanup.

								Honza
