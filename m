From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 24 Oct 2008 17:02:28 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: Proper hash collision
 handle in bucket division.v2
In-Reply-To: <20081024084738.GE31082@ca-server1.us.oracle.com>
References: <1224218678-32196-3-git-send-email-tao.ma@oracle.com>
	<1224204876-26802-1-git-send-email-tao.ma@oracle.com>
	<20081023232030.GE12751@mail.oracle.com>
	<49011C51.1030806@oracle.com>
	<20081024011451.GH12751@mail.oracle.com>
	<490124A0.1020407@oracle.com>
	<20081024060238.GB31082@ca-server1.us.oracle.com>
	<49016807.9000901@oracle.com>
	<20081024074353.GC31082@ca-server1.us.oracle.com>
	<20081024084738.GE31082@ca-server1.us.oracle.com>
Message-ID: <49018F24.3000607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Fri, Oct 24, 2008 at 12:43:53AM -0700, Joel Becker wrote:
>> On Fri, Oct 24, 2008 at 02:15:35PM +0800, Tao Ma wrote:
>>> Joel Becker wrote:
>>>> 	I have an idea to do what you're doing, but cleaner.  I'll look
>>>> at cmp_xe and try again in the morning.
>>> cool, so waiting for your perfect code. ;)
>> Zing!  You got me :-)
> 
> 	How's this (untested)?
> 
> /*
>  * If this ocfs2_xattr_header covers more than one hash value, find a
>  * place where the hash value changes.  Try to find the most even split.
>  * The most common case is that all entries have different hash values,
>  * and the first check we make will find a place to split.
>  */
> static int ocfs2_xattr_find_divide_pos(struct ocfs2_xattr_header *xh)
> {
> 	struct ocfs2_xattr_entry *entries = &xh->xh_entries;
> 	int count = le16_to_cpu(xh->xh_count);
> 	int delta, middle = count / 2;
> 
> 	/*  
> 	 * We start at the middle.  Each step gets farther away in both
> 	 * directions.  We therefore hit the change in hash value
> 	 * nearest to the middle.  Note that this loop does not execute for
> 	 * count < 2.
> 	 */
> 	for (delta = 0; delta < middle; delta++) {
> 		/* Let's check delta earlier than middle */
> 		if (!cmp_ex(&entries[middle - delta - 1], 
> 			    &entries[middle - delta]))
> 			return middle - delta;
> 		/* For even counts, don't walk off the end */
> 		if ((middle + delta + 1) == count)
> 			continue;
> 		/* Now try delta past middle */
> 		if (!cmp_ex(&entries[middle + delta],
> 			    &entries[middle + delta + 1]))
> 			return middle + delta + 1;
> 	}
> 
> 	/* Every entry had the same hash */
> 	return count;
> }
yeah, this looks perfect and more efficient.
I will modify my patch and then test it.

Thanks.

Regards,
Tao
