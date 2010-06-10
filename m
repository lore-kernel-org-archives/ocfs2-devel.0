From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 9 Jun 2010 17:56:53 -0700
Subject: [Ocfs2-devel] [PATCH] Reoganize data elements to reduce memory
 footprint
In-Reply-To: <20100610004509.GA27385@mail.oracle.com>
References: <AANLkTinTCrwXLiCjOm4l7uIzjRSz-17vJLLhNaCMDFJa@mail.gmail.com>
	<20100610004509.GA27385@mail.oracle.com>
Message-ID: <20100610005652.GD27385@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 09, 2010 at 05:45:10PM -0700, Joel Becker wrote:
> 	I think you should change l_type, l_action, l_requested,
> l_blocking, and l_level to unsigned char.  While the enums that set them

	I missed l_unlock_action.  That one too.

> should be not modified, they do not have more than 256 values.  All the
> functions around them can use the enum type in their arguments.  Just
> the ocfs2_lock_res itself stores them in unsigned char.
> 	This would potentially save us 15 bytes per ocfs2_lock_res,
> 45 per inode.  More realistic is probably 12 per lock_res and 36 per
> inode, but still!

	So that's 18 bytes per ocfs2_lock_res, 54 per inode.  Of course,
alignment probably costs us 2 per lock_res, so call it 48 per inode of
real savings.  Nice!

Joel

[Thanks to Tao for noticing I missed l_unlock_action]

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
