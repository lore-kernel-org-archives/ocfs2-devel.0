From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed, 16 Apr 2008 12:10:03 -0700
Subject: [Ocfs2-devel] dentry locks
In-Reply-To: <20080416190304.GC31299@wotan.suse.de>
References: <48055C53.9090809@oracle.com>
	<20080416182020.GB31299@wotan.suse.de>
	<48064582.5020305@oracle.com>
	<20080416190304.GC31299@wotan.suse.de>
Message-ID: <48064F0B.1040900@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I understand that. I am looking to switch the order in the name.
As in, N<block# in hex>NULL<parent# in bin>. Maybe change N to T
to prevent confusion.

Any harm in the above?

The issue is not with debugfs but to help cull the number of tcpdumps
to wade thru.

Mark Fasheh wrote:
> On Wed, Apr 16, 2008 at 11:29:22AM -0700, Sunil Mushran wrote:
>   
>> Not both in hex. I meant block# in hex and parent in binary.
>> The only clash this way will be for hard links.
>>     
>
> Right, what I meant is that we can't print both in hex due to size
> constraints. So, one was kept in hex and the other in binary. In theory,
> they could have both been binary but I figured that we might as well have
> *something* to printf:
>
> 	/*
> 	 * Unfortunately, the standard lock naming scheme won't work
> 	 * here because we have two 16 byte values to use. Instead,
> 	 * we'll stuff the inode number as a binary value. We still
> 	 * want error prints to show something without garbling the
> 	 * display, so drop a null byte in there before the inode
> 	 * number. A future version of OCFS2 will likely use all
> 	 * binary lock names. The stringified names have been a
> 	 * tremendous aid in debugging, but now that the debugfs
> 	 * interface exists, we can mangle things there if need be.
> 	 *
> 	 * NOTE: We also drop the standard "pad" value (the total lock
> 	 * name size stays the same though - the last part is all
> 	 * zeros due to the memset in ocfs2_lock_res_init_once()
> 	 */
>
>
>   
>> I ran into this while debugging the extra downconvert on dentry locks.
>> Even if I teach the ocfs2 dissector to handle the dentry lock, I won't
>> be able to trim down enough the number of tcpdumps to wade thru (using
>> grep, that is). Block# in hex will help.
>>     
>
> Well, there's not really much we can do for what's on the wire. The debugfs
> interface at least seems to print it in hex for you.
> 	--Mark
>
> --
> Mark Fasheh
>   
