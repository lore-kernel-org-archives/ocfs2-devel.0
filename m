From: Zach Brown <zach.brown@oracle.com>
Date: Fri, 10 Mar 2006 16:44:21 -0800
Subject: [Ocfs2-devel] Another ocfs2 performance bug
In-Reply-To: <4411FE80.7030302@google.com>
References: <4411FE80.7030302@google.com>
Message-ID: <44121D65.5010004@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Phillips <phillips@google.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com


> Reading all the files in a big directory tree takes at least four times
> as long on ocfs2 as ext3.

> real   1m54.933s  <===

> real    0m23.899s <===

Can you doctor your scripts to show@least some overview of the IO
patterns?  Just the amount of reads and writes would be a good start,
but something like graphing blktrace output would be wildly instructive.

My first guess would be the known difference between OCFS2's full-block
inodes and ext3's habit of packing lots of inode structs into a block.

Secondary guesses would be lack of directory read-ahead, bad IO patterns
based on allocation policy, etc..

- z
