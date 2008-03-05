From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 17:14:26 2008
Subject: [Ocfs2-devel] [PATCH 0/10] ocfs2: Userspace cluster stack support
Message-ID: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mark.fasheh@oracle.com, teigland@redhat.com

These patches allow ocfs2 to use the distributed lock manager in fs/dlm
in conjunction with a userspace cluster stack.

This series builds on the stack-glue series sent previously.  It
provides a plug-in for userspace cluster stacks and fs/dlm.  Userspace
is responsible for communicating with the cluster stack and feeding
events through the ocfs2_control misc device.  ocfs2 is otherwise
agnostic, using the DLM for all of its interaction.

Using the new ocfs2_stack_user plug-in requires a development version of
the ocfs2 tools.  This version knows how to load the plug-in and
provides a daemon to interact with the cman cluster stack.

The second to last patch enables the plug-in in Kbuild.  The last patch
adds Kconfig options to select which ocfs2 cluster plug-ins get built.

The kernel code is also available on the 'stack-user' branch of my git
repository.

View:
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=stack-user
Pull:
git pull git://oss.oracle.com/git/jlbec/linux-2.6.git stack-user

The tools code is also available via git, in the 'stack-user' branch
as well.

View:
http://oss.oracle.com/git/?p=ocfs2-tools.git;a=shortlog;h=stack-user
Pull:
git pull git://oss.oracle.com/git/ocfs2-tools.git stack-user
