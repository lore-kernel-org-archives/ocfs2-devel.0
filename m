From: John Haxby <john.haxby@oracle.com>
Date: Tue, 24 Nov 2015 21:07:00 +0000
Subject: [Ocfs2-devel] [PATCH 0/1] ocfs2: return non-zero st_blocks for
	inline data [resend2]
Message-ID: <1448399221-6109-1-git-send-email-john.haxby@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello All,

[Really sorry about this and I hope you're not getting fed up of
 multiple copies of this message but the list on oss.oracle.com really
 doesn't like me.]

Some programs, and programmers, assume that if a file is occupying
zero blocks (st_blocks == 0) then it contains no data and there's no
point in reading it.  Posix doesn't actually say anything about this,
but it seems to be something a lot of people expect. Indeed, ext4,
btrfs and ntfs-3d all seem to behave this way so that no one[1] has
any unpleasant surprises.

This patch is almost exactly the same as commit 9206c561554c ("ext4:
return non-zero st_blocks for inline data") although I couldn't bring
myself to include the typo in the comment :)

jch

[resend because rejected by list the first time.]
[1] tar, I'm looking at you, but you're not the only one.


John Haxby (1):
  ocfs2: return non-zero st_blocks for inline data

 fs/ocfs2/file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

-- 
2.5.0
