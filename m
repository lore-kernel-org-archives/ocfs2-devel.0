From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Feb 17 19:18:45 2004
Subject: [Ocfs2-devel] Re: [PATCH]removing oin from ocfs_file
In-Reply-To: <200402171845.i1HIjARf004739@penguin.co.intel.com>
References: <200402171845.i1HIjARf004739@penguin.co.intel.com>
Message-ID: <20040218011840.GN26331@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 17, 2004 at 10:45:10AM -0800, Rusty Lynch wrote:
> Here is a very small patch to svn version 31 that removes
> the unused oin pointer in the ocfs_file structure (as
> called for in the TODO list.)
> 
> Verified that the field really isn't being used anywhere.
Looks good. I'll commit this tonight.
	--Mark


--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
