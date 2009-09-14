From: Coly Li <coly.li@suse.de>
Date: Tue, 15 Sep 2009 04:23:40 +0800
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4AAE99DF.3030005@oracle.com>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
	<4A9EA759.5090906@suse.de> <4A9EEB26.2080204@oracle.com>
	<4A9FEDA8.3080108@suse.de> <4A9FEDAC.50704@oracle.com>
	<4AA80AE4.9090105@suse.de> <4AA82136.9000403@oracle.com>
	<4AA890ED.3040406@suse.de> <4AAAD5C6.4000800@oracle.com>
	<4AACFCEB.4060902@suse.de> <4AAE99DF.3030005@oracle.com>
Message-ID: <4AAEA64C.3030607@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> Thanks. Can you email me the _full_ trace log.
> 
Hi Sunil,

Here is the full trace log from boot to shutdown, on both nodes.

On node x1, I run 2 make_panic process (the simplified bash script).
On node x2, I run 1 make_panic process.

The above operation can reproduce the blocking very fast. I wait for several
minutes, when no any new file created on both nodes. Then I shut the nodes.

Please check the attachment for trace log.

Thanks.
-- 
Coly Li
SuSE Labs
-------------- next part --------------
A non-text attachment was scrubbed...
Name: calltrace_x1.bz2
Type: application/x-bzip
Size: 49891 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090915/264a25bf/attachment-0002.bin 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: calltrace_x2.bz2
Type: application/x-bzip
Size: 48514 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090915/264a25bf/attachment-0003.bin 
