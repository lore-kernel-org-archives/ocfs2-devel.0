From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Feb 27 21:08:00 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in inode.c
In-Reply-To: <200402251541.i1PFff84029171@penguin.co.intel.com>
References: <200402251541.i1PFff84029171@penguin.co.intel.com>
Message-ID: <20040228030756.GR1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 25, 2004 at 07:41:41AM -0800, Rusty Lynch wrote:
> The following patch fixes some more 2.6 issues that come out of
> porting inode.c
> 
> * In 2.6, direct-io is accomplished by just providing a direct_IO
>   mechanism in the address_space_operations.  This means there is
>   no need to treat direct IO differently in read/write operations.
> * There were a couple of more timespec related bumps
> * A typo in 2.6 code for handling inode devices
> * Several more 2.6 prototype variants that cause compiler
>   errors/warnings
> * Small changes in the inode structure

Ok, just got this in CVS. Some of your logic for the prototypes was a little
less strict than I wanted so I changed it around a bit :)
	--Mark


--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
