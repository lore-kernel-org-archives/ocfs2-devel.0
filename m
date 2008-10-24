From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 24 Oct 2008 08:52:33 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: Proper hash collision
 handle in bucket division.v2
In-Reply-To: <20081023232030.GE12751@mail.oracle.com>
References: <1224218678-32196-3-git-send-email-tao.ma@oracle.com>
	<1224204876-26802-1-git-send-email-tao.ma@oracle.com>
	<20081023232030.GE12751@mail.oracle.com>
Message-ID: <49011C51.1030806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
>> @@ -3267,25 +3267,92 @@ static int ocfs2_read_xattr_bucket(struct inode *inode,
>>  }
>>  
>>  /*
>> - * Move half num of the xattrs in old bucket(blk) to new bucket(new_blk).
>> + * Find the suitable pos when we divide a bucket into 2.
>> + *
>> + * We have to make sure the xattrs with the same hash value exist in the same
>> + * bucket. So we start from the middle pos and go backward first and then
>> + * forward. If all the xattrs in this bucket have the same hash value, just
>> + * return count-1 and let the caller handle this.
>> + */
>> +static u16 ocfs2_xattr_find_divide_pos(struct ocfs2_xattr_header *xh)
>> +{
>> +	u16 middle, pos, count = le16_to_cpu(xh->xh_count);
>> +	struct ocfs2_xattr_entry *xe, *xe_low;
>> +
>> +	BUG_ON(count == 0);
>> +	middle = count / 2;
>> +
>> +	/*
>> +	 * If the bucket only have one xattr(for blocksize == 512 and large
>> +	 * xattr name, it could be possible), let it go.
>> +	 */
>> +	if (middle == 0)
>> +		return middle;
>> +
>> +	/*
>> +	 * Find a xe before middle which doesn't have the same hash value
>> +	 * with the previous one.
>> +	 */
>> +	pos = middle;
>> +	while (pos > 0) {
>> +		xe = &xh->xh_entries[pos];
>> +		xe_low = &xh->xh_entries[pos - 1];
>> +		if (le32_to_cpu(xe_low->xe_name_hash) !=
>> +		    le32_to_cpu(xe->xe_name_hash))
>> +			return pos;
>> +
>> +		pos--;
>> +	}
>> +
>> +	/* now all the xe before middle(include it) has the same hash value. */
>> +	if (middle == count - 1)
>> +		return middle;
>> +
>> +	/*
>> +	 * Find a xe after middle which doesn't have the same hash value
>> +	 * with the later one.
>> +	 */
>> +	pos = middle;
>> +	while (pos < count - 1) {
>> +		xe_low = &xh->xh_entries[pos];
>> +		xe = &xh->xh_entries[pos + 1];
>> +		if (le32_to_cpu(xe_low->xe_name_hash) !=
>> +		    le32_to_cpu(xe->xe_name_hash))
>> +			return pos + 1;
>> +
>> +		pos++;
>> +	}
>> +
>> +	/* now all the xe in the bucket hash the same hash value. */
>> +	return count - 1;
>> +}
> 
> 	Do we really need such a complex function?  Some of your
> bailouts don't even help much.  I *think* what you are doing here is
> trying to find the hash value change closest to the middle.
> Also, you don't need to pass around u16s.  It just makes the code
> more complex.
> 	What about:
> 
> /* In an ocfs2_xattr_header, are the hashes of entries n and n+1 equal?. */
> static inline int xe_cmp(struct ocfs2_xattr_entry *entres, int n)
> {
> 	return le32_to_cpu(entries[n].xe_name_hash) ==
> 		le32_to_cpu(entries[n + 1].xe_name_hash);
> }
> 
> /*
>  * If this ocfs2_xattr_header covers more than one hash value, find a
>  * place where the hash value changes.  Try to find the most even split.
>  */
> static int ocfs2_xattr_find_divide_pos(struct ocfs2_xattr_header *xh)
> {
> 	int i, middle, pos = 0, count = le16_to_cpu(xh->xh_count);
> 
> 	middle = count / 2;
> 
> 	/* It's important that this loop does nothing for count < 2 */
> 	for (i = 0; i < (count - 1), i++) {
> 		if (xe_cmp(xh->xh_entries, i)) {
> 			/* If the hash flips at the middle, it's perfect */
> 			if (i == middle)
> 				return i;
> 
> 			/* Cache the highest pos before middle */
> 			if (i < middle)
> 				pos = i;
> 			else {
> 				/* Which is closer to middle, pos or i? */
> 				if ((middle - pos) > (i - middle))
> 					pos = i;
> 				return pos;
> 			}
> 		}
> 	}
> 
> 	/* If pos is 0, every entry had the same hash. */
> 	if (!pos)
> 		pos = count;
> 
> 	return pos;
> }
Don't agree. Actually in most cases we won't be so lucky to hit this 
situation(I run the test scripts many times and hit one), so I think 
most times we will just return "middle" and my function go out 
immediately, it is O(1). You function suppose that the hash collision 
happens frequently and iterate the half of the xh_entries so it is O(n).

Regards,
Tao
