From: Coly Li <coly.li@suse.de>
Date: Tue, 15 Sep 2009 15:11:32 +0800
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4AAED882.9020601@oracle.com>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
	<4A9EA759.5090906@suse.de> <4A9EEB26.2080204@oracle.com>
	<4A9FEDA8.3080108@suse.de> <4A9FEDAC.50704@oracle.com>
	<4AA80AE4.9090105@suse.de> <4AA82136.9000403@oracle.com>
	<4AA890ED.3040406@suse.de> <4AAAD5C6.4000800@oracle.com>
	<4AACFCEB.4060902@suse.de> <4AAE99DF.3030005@oracle.com>
	<4AAEA64C.3030607@suse.de> <4AAED882.9020601@oracle.com>
Message-ID: <4AAF3E24.9050207@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> The full trace is available here.
> http://oss.oracle.com/~smushran/calltrace_x1
> 
> So one sees the following block repeated. It shows that the lock is
> being downconverted from EX to NL but also upconverted presumably to EX.
> 
> 
> Coli, Can you map the pids to the process names.
> 

Hi Sunil,

In the attached trace info, I add current->comm after the pid.

Here is the steps I reproduce the blocking,
- This time I only run 1 make_panic process on each node.
- I ran make_panic on x1 firstly, then on x2.
- On node x1, after creating 3-4 files, I start the make_panic script on node x2.
- On node x2, make_panic blocked immediately, no file created. On node x1, after
creating 13 files, make_panic blocked too.
- After waiting for several minutes, still blocked. I stop gathering trace info.

Please check the attachment. Thank.

-- 
Coly Li
SuSE Labs
-------------- next part --------------
A non-text attachment was scrubbed...
Name: calltrace_x1.bz2
Type: application/x-bzip
Size: 46329 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090915/f528a475/attachment-0002.bin 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: calltrace_x2.bz2
Type: application/x-bzip
Size: 44701 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090915/f528a475/attachment-0003.bin 
