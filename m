From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 21 Aug 2009 11:04:11 +0800
Subject: [Ocfs2-devel] [PATCH 17/41] ocfs2: Add CoW support.
In-Reply-To: <20090821025136.GK10558@mail.oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-17-git-send-email-tao.ma@oracle.com>
	<20090821005932.GE10558@mail.oracle.com>
	<4A8E00A2.1050902@oracle.com>
	<20090821025136.GK10558@mail.oracle.com>
Message-ID: <4A8E0EAB.7070001@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Fri, Aug 21, 2009 at 10:04:18AM +0800, Tao Ma wrote:
>> Joel Becker wrote:
>>> On Tue, Aug 18, 2009 at 02:19:18PM +0800, Tao Ma wrote:
>>>> +		if (*cow_len + leaf_clusters >= max_clusters) {
>>>> +			if (*cow_len == 0) {
>>>> +				/*
>>>> +				 * cpos is in a very large extent record.
>>>> +				 * So just split max_clusters from the
>>>> +				 * extent record.
>>>> +				 */
>>>> +				if ((rec_end - cpos) <= max_clusters) {
>>>> +					/*
>>>> +					 * We can take max_clusters off
>>>> +					 * the end and cover all of our
>>>> +					 * write.
>>>> +					 */
>>>> +					*cow_start = rec_end - max_clusters;
>> oh, yes, this is really a bug. I guess the reason why tristan's test 
>> case can't find it is that we are now called from ocfs2_write_begin. 
>> Normally the write_len will at most be a PAGE_SIZE and the start is 
>> aligned to PAGE_SIZE also. With our x86_64 boxes, PAGE_SIZE=4096, we 
>> always CoW the right pos. But with PAGE_SIZE=64k, it will be exposed.
>> So how about change the first check to:
>> 			if (((rec_end - cpos) <= max_clusters) &&
>> 			    (cpos + write_len <= rec_end)) {
> 
> 	This doesn't quite work either, because we'll then fall to the
> else{, which is for ranges in the middle of a big cluster.
> 	Essentially, the problem is one of max_clusters not seeing the
> extra stuff we've done on the front of the I/O.  And I think that comes
> down to the confusion of max_clusters vs write_len.  We want to CoW at
> least cpos+write_len, but we want large extents broken on the 1MB
> boundary. 
> 	We have another problem.  What if we have two refcounted
> extents each of 1MB in size.  We're doing a 1.5MB starting at the
> beginning of the first extent.  First we get 1MB from the first extent.
> We go back around the loop to the second extent.  We see that *cow_len +
> leaf_clusters (1MB + 1MB) is greater than the 1.5MB we're trying to
> write.  So we set *cow_len to our 1.5MB.  But this is going to break the
> second extent up into two .5MB extents.  What we really want is to cow
> that entire second 1MB extent.
oh, actually I drafted up this code in the hypothesis that write_len <= 
max_clusters, so if we want to write 1.5MB, I am afraid we need to 
rethink it carefully.
> 
>>>> +				} else if ((*cow_start + max_clusters) >
>>>> +					   (cpos + write_len)) {
>>> 	Should this be >=?  I think it should be, and I think it's my
>>> fault.  But check to make sure.
>> yeah, ">=" will be more accurate. Actually, with ">", we can survive in 
>> a less efficient way since the "else" will cover this case and CoW a 
>> different part(start from another pos).
> 
> 	Let's do the >=, which is best.
ok.
> 
> 	I'm halfway through a modification of this code that splits out
> MAX_COW_BYTES from write_len.  Let me finish it tomorrow.
really? that would be cool. and then my hypothesis mentioned above will 
not be a problem.

Regards,
Tao
