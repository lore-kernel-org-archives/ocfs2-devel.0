From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 13 Feb 2012 12:17:15 -0800
Subject: [Ocfs2-devel] [patch] ocfs2: cleanup error handling in
	o2hb_alloc_hb_set()
In-Reply-To: <20120213200835.GK4141@mwanda>
References: <20120213135047.GA10683@elgon.mountain>
	<4F3966EF.9070405@oracle.com> <20120213200835.GK4141@mwanda>
Message-ID: <4F396FCB.6060506@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 02/13/2012 12:08 PM, Dan Carpenter wrote:
> On Mon, Feb 13, 2012 at 11:39:27AM -0800, Sunil Mushran wrote:
>> hmm... I would say NAK because config_group_item_type_name() could
>> change in the future. And there is nothing wrong with the current
>> code.
>
> The error handling isn't correct because checking "&hs->hs_group"
> for NULL doesn't work.  "hs" and "&hs->hs_group" are the same
> address and we checked "hs" already.  If we wanted to check for
> allocation errors, then we would need to change the check to:
>
>          if (!hs->hs_group.cg_item.ci_name)
> 		kfree(hs);
>
> But that's not how the function is supposed to be used.  The example
> code in Documentation/filesystems/configfs/configfs_example_explicit.c
> doesn't have error handling.


True. The error handling is not ideal but only so because it
has not been specified. A better fix would be to first clarify that
in config_group_item_type_name().
