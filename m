From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Tue, 8 Jan 2013 11:11:37 -0500
Subject: [Ocfs2-devel] NULL pointer deref in OCFS2_IOC_MOVE_EXT
Message-ID: <CADGQE7HNSWGThWEudE6Hmu2ws6yFPmSxZRrwbXs7vrkFXD4Qwg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It appears that if a user calls ioctl(OCFS2_IOC_MOVE_EXT) and does not
set OCFS2_MOVE_EXT_FL_AUTO_DEFRAG in range.me_flags, the kernel will
invoke ocfs2_validate_and_adjust_move_goal.  That function
dereferences the 'bg' pointer (initialized to NULL) before it assigns
anything else to 'bg'.

One possible fix is to revert
ea5e1675ac832b42889ac8d254ea8fbfbdfaa8b2, which is when the code in
ocfs2_validate_and_adjust_move_goal was moved in a way that guaranteed
a NULL pointer dereference.  But I don't fully understand what that
change was trying to achieve.

Nickolai.
