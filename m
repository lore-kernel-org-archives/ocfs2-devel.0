From: Andreas Dilger <adilger@dilger.ca>
Date: Thu, 17 Jul 2014 00:07:57 -0600
Subject: [Ocfs2-devel] [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED
	flag
In-Reply-To: <9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
References: <cover.1386778302.git.dsterba@suse.cz>
	<4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
	<20131212232443.GL31386@dastard>
	<9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
Message-ID: <B58DEEA8-561A-4173-B9F5-528B73E06C6D@dilger.ca>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Sterba <dsterba@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, Btrfs Developer List <linux-btrfs@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com

David,
any progress on this patch series?

I never saw an updated version of this patch series after the last round of
reviews, but it would be great to move it forward.  I have filefrag patches
in my e2fsprogs tree waiting for an updated version of your patch.

I recall the main changes were:
- add FIEMAP_EXTENT_PHYS_LENGTH flag to indicate if fe_phys_length was valid
- rename fe_length to fe_logi_length and #define fe_length fe_logi_length
- always fill in fe_phys_length (= fe_logi_length for uncompressed files)
  and set FIEMAP_EXTENT_PHYS_LENGTH whether the extent is compressed or not
- add WARN_ONCE() in fiemap_fill_next_extent() as described below

I don't know if there was any clear statement about whether there should be
separate FIEMAP_EXTENT_PHYS_LENGTH and FIEMAP_EXTENT_DATA_COMPRESSED flags,
or if the latter should be implicit?  Probably makes sense to have separate
flags.  It should be fine to use:

#define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010

since this flag was never used.

Cheers, Andreas

On Dec 12, 2013, at 5:02 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Dec 12, 2013, at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Thu, Dec 12, 2013 at 04:25:59PM +0100, David Sterba wrote:
>>> This flag was not accepted when fiemap was proposed [2] due to lack of
>>> in-kernel users. Btrfs has compression for a long time and we'd like to
>>> see that an extent is compressed in the output of 'filefrag' utility
>>> once it's taught about it.
>>> 
>>> For that purpose, a reserved field from fiemap_extent is used to let the
>>> filesystem store along the physcial extent length when the flag is set.
>>> This keeps compatibility with applications that use FIEMAP.
>> 
>> I'd prefer to just see the new physical length field always filled
>> out, regardless of whether it is a compressed extent or not. In
>> terms of backwards compatibility to userspace, it makes no
>> difference because the value of reserved/unused fields is undefined
>> by the API. Yes, the implementation zeros them, but there's nothing
>> in the documentation that says "reserved fields must be zero".
>> Hence I think we should just set it for every extent.
> 
> I'd actually thought the same thing while reading the patch, but I figured
> people would object because it implies that old kernels will return a
> physical length of 0 bytes (which might be valid) and badly-written tools
> will not work correctly on older kernels.  That said, applications _should_
> be checking the FIEMAP_EXTENT_DATA_COMPRESSED flag, and I suspect in the
> future fewer developers will be confused if fe_phys_length == fe_length
> going forward.
> 
> If the initial tools get it right (in particular filefrag), then hopefully
> others will get it correct also.
> 
>> From the point of view of the kernel API (fiemap_fill_next_extent),
>> passing the physical extent size in the "len" parameter for normal
>> extents, then passing 0 for the "physical length" makes absolutely
>> no sense.
>> 
>> IOWs, what you have created is a distinction between the extent's
>> "logical length" and it's "physical length". For uncompressed
>> extents, they are both equal and they should both be passed to
>> fiemap_fill_next_extent as the same value. Extents where they are
>> different (i.e.  encoded extents) is when they can be different.
>> Perhaps fiemap_fill_next_extent() should check and warn about
>> mismatches when they differ and the relevant flags are not set...
> 
> Seems reasonable to have a WARN_ONCE() in that case.  That would catch bugs
> in the filesystem, code as well:
> 
> 	WARN_ONCE(phys_len != lgcl_len &&
> 		  !(flags & FIEMAP_EXTENT_DATA_COMPRESSED),
> 		  "physical len %llu != logical length %llu without DATA_COMPRESSED\n",
> 		  phys_len, logical_len, phys_len, logical_len);
> 
>>> diff --git a/include/uapi/linux/fiemap.h b/include/uapi/linux/fiemap.h
>>> index 93abfcd..0e32cae 100644
>>> --- a/include/uapi/linux/fiemap.h
>>> +++ b/include/uapi/linux/fiemap.h
>>> @@ -19,7 +19,9 @@ struct fiemap_extent {
>>> 	__u64 fe_physical; /* physical offset in bytes for the start
>>> 			    * of the extent from the beginning of the disk */
>>> 	__u64 fe_length;   /* length in bytes for this extent */
>>> -	__u64 fe_reserved64[2];
>>> +	__u64 fe_phys_length; /* physical length in bytes, undefined if
>>> +			       * DATA_COMPRESSED not set */
>>> +	__u64 fe_reserved64;
>>> 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
>>> 	__u32 fe_reserved[3];
>>> };
>> 
>> The comment for fe_length needs to change, too, because it needs to
>> indicate that it is the logical extent length and that it may be
>> different to the fe_phys_length depending on the flags that are set
>> on the extent.
> 
> Would it make sense to rename fe_length to fe_logi_length (or something,
> I'm open to suggestions), and have a compat macro:
> 
> #define fe_length fe_logi_length
> 
> around for older applications?  That way, new developers would start to
> use the new name, old applications would still compile for both newer and
> older interfaces, and it doesn't affect the ABI at all.
> 
>> And, FWIW, I wouldn't mention specific flags in the comment here,
>> but do it at the definition of the flags that indicate there is
>> a difference between physical and logical extent lengths....
> 
> Actually, I was thinking just the opposite for this field.  It seems useful
> that the requirement for DATA_COMPRESSED being set is beside fe_phys_length
> so that anyone using this field sees the correlation clearly.  I don't expect
> everyone would read and understand the meaning of all the flags when looking
> at the data structure.
> 
> Cheers, Andreas
> 
>>> @@ -50,6 +52,8 @@ struct fiemap {
>>> 						    * Sets EXTENT_UNKNOWN. */
>>> #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can not be read
>>> 						    * while fs is unmounted */
>>> +#define FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is compressed by fs.
>>> +						    * Sets EXTENT_ENCODED */
>> 
>> i.e. here.
>> 
>> Cheers,
>> 
>> Dave.
>> -- 
>> Dave Chinner
>> david at fromorbit.com
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


Cheers, Andreas





-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 833 bytes
Desc: Message signed with OpenPGP using GPGMail
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140717/4f0c7e15/attachment.bin 
