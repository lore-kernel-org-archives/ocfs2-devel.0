From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 28 Jan 2015 14:12:02 -0800
Subject: [Ocfs2-devel] [PATCH 0/6] ocfs2-tools: userspace clustering updates
Message-ID: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

The following series of patches updates ocfs2-tools to work with the latest
userspace clustering releases from SUSE. Kernel clustering (o2cb)
functionality is not changed.

The first 3 patches teach ocfs2-tools about the nocontrold feature
which Goldwyn implemented last year.

https://oss.oracle.com/pipermail/ocfs2-tools-devel/2014-February/004161.html

The following 3 add on to that to allow ocfs2-tools to setup a cluster
stack (if not already setup) based on the stack specified in the fs
superblock. If the stack is not available the command will fail as it
normally does.

The last patch is just a small cleanup I added while I was testing
these changes.

Other than my own testing (to make sure nothing broke), these have
been shipping in SUSE for over a year now.

Thanks!
     --Mark
