From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Apr 27 13:28:18 2004
Subject: [Ocfs2-devel] system halt when create a directory in ocfs2 volume
	(svn 866 kernel 2.6)
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65E86@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65E86@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040427182313.GV10471@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 27, 2004 at 04:47:49PM +0800, Zhang, Sonic wrote:
> Hi,
> 
> 	When create a directory, system halts with error information.
> This bug is found since svn 866 in kernel 2.6. Because we fail to mount
> an ocfs volume under kernel 2.4 with this version of driver, we can't
> make sure if it is kernel independent. 
We've seen some possibly similar behavior on an x86-64 box we've got over
here. Can you tell me what hardware you're running on? Also, do you have a
stack trace?
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
