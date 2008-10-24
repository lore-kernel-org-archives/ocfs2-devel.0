From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:05:04 +0200
Subject: [Ocfs2-devel] [PATCH 00/00] Implement quotas for OCFS2 (version 2)
In-Reply-To: yes
References: yes
Message-ID: <12248859043309-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

the following patch series implements quotas for OCFS2. The patch
series is based on:
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git linux-next

I've adressed Joel's comments, also node recovery is now fully working
and I've fixed a few issues I found during my testing. So I'm currently
not aware of any bugs. Please review, test, comment. Thanks.

								Honza
