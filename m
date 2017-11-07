From: Eric Ren <zren@suse.com>
Date: Tue, 7 Nov 2017 10:31:04 +0800
Subject: [Ocfs2-devel] ocfs2-test result on 4.14.0-rc7-1.gdbf3e9b-vanilla
	kernel
In-Reply-To: <b1b90077-b13f-9d36-4f0e-938f1be7a795@suse.com>
References: <b1b90077-b13f-9d36-4f0e-938f1be7a795@suse.com>
Message-ID: <0c53b4a2-91ac-44ca-527f-6f5f0b6bd7a4@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

The testing result against the recent kernel looks good. The attachments are
overall results. If the detailed logs are needed, please let me know.

Pattern				Failed	Passed	Skipped	Total
DiscontigBgMultiNode 		0 	4 	0 	4
DiscontigBgSingleNode 		0 	5 	0 	5
MultipleNodes 			0 	9 	1 	10
SingleNode 			0 	18 	1 	19

Notes:
- This testing only use blocksize=4096 and clustersize=32768 to reduce the time;
- The 2 skipped cases are on purpose: filecheck and lvb_torture.

Cheers,
Eric

-------------- next part --------------
A non-text attachment was scrubbed...
Name: single_run.log
Type: application/octet-stream
Size: 6372 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171107/6c136d1a/attachment.obj 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: multiple-run-x86_64-2017-11-06-19-57-44.log
Type: application/octet-stream
Size: 1072 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171107/6c136d1a/attachment-0001.obj 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 2017-11-06-21-24-07-discontig-bg-single-run.log
Type: text/x-log
Size: 527 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171107/6c136d1a/attachment.bin 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 2017-11-07-01-35-34-discontig-bg-multiple-run.log
Type: text/x-log
Size: 539 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171107/6c136d1a/attachment-0001.bin 
