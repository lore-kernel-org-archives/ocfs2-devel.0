From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 16:28:11 2008
Subject: [Ocfs2-devel] [PATCH 0/18] ocfs2: Cluster stack glue layer
Message-ID: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mark.fasheh@oracle.com

ocfs2 is currently tied to its internal cluster stack, the ocfs2 Cluster
Base (o2cb).  This includes the nodemanager (o2nm) and distributed lock
manager (o2dlm).

Going forward, ocfs2 would like to use the DLM in fs/dlm.  This includes
interacting with userspace cluster stacks that drive fs/dlm, allowing
all clustering on a machine to use the same stack.

This patch series decouples the o2cb stack from ocfs2, creating a
plug-in architecture.  A layer called "stackglue" sits between the ocfs2
filesystem and the chosen cluster plug-in.  A later patch series will
introduce the plug-in for fs/dlm and userspace cluster stacks.

The series should be functionally equivalent.  Each patch should compile
and run successfully, with no modification to userspace tools.  The end
result of this series is a plug-in cluster backend that behaves exactly
as the current system does.  As an added benefit, local (non-clustered)
ocfs2 filesystems do not need to load any plug-in.  In the past, even a
non-clustered filesystem required the o2cb modules loaded, though not
configured.

The kernel code is also available on the 'stack-glue' branch of my git
repository.

View:
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=stack-glue
Pull:
git pull git://oss.oracle.com/git/jlbec/linux-2.6.git stack-glue
