From: Gang He <ghe@suse.com>
Date: Thu, 11 Aug 2016 00:03:08 -0600
Subject: [Ocfs2-devel] About ocfs2 file sytem fragmentation tool
Message-ID: <57AC859C020000F9000456B9@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Guys,

Our customer is asking one question, how to detect a ocfs2 file system fragmentation status.
Current, I can think of ways for detecting fragmentation as below,
1) o2info --freefrag N /dev/vdb3
this command can give some information for how many free chunks (based on size) are here,
but it can not give any conclusive information, e.g. the file system is fragmented, or not.  fragmentation ratio.
2) debugfs.ocfs2 -R "frag /fio1/test1"  /dev/vdb3
this command can give some information only for one file, how to get the whole volume information, e.g. the file system fragmentation ratio.

So, anybody can give some suggestion for ocfs2 file system fragmentation tool, it is very appreciated.
For example, there is any more better way to detect the file system fragmentation ratio.
The further question, if there are some free blocks in the file system, but the user cannot create a file, it is also related to fragmentation problem?
The use have to use "discontig-bg" feature to overcome this problem?


Thanks
Gang
