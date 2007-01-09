From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  9 14:28:10 2007
Subject: [Ocfs2-devel] Fixing cluster/heartbeat.c's use of bio_add_page()
In-Reply-To: <200701051506.52840.philipp.reisner@linbit.com>
References: <200701051506.52840.philipp.reisner@linbit.com>
Message-ID: <20070109222804.GY6831@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Philipp,

On Fri, Jan 05, 2007 at 03:06:52PM +0100, Philipp Reisner wrote:
> Hi There,
> 
> As was already pointed out Mathieu Avila on Thu, 07 Sep 2006 03:15:25 -0700
> that OCFS2 is expecting bio_add_page() to add pages to BIOs in an easily
> predictable manner.
> 
> That is not true, especially for devices with own merge_bvec_fn().
> 
> Therefore OCFS2's heartbeat code is very likely to fail on such devices.
> 
> The attached patch corrects this, and reduces the file cluster/heartbeat.c
> by 90 lines.

Thanks for taking this on - fixing up that code has been on my todo list for
a while.


>   The whole patch builds around the change that the bio_put() call is
>   moved to the bio's bi_end_io() function.
>   This makes the whole idea of trying to predict the behaviour of 
>   bio_add_page() unnecessary, therefore we can remove compute_max_sectors()
>   and o2hb_compute_request_limits().
> 
> -Phil
> 
> PS1: With that applied I can happily run OCFS2 on a DRBD-8.0 device which
>      sits on top of software raid (both have interesting merge_bvec_fn()
>      functions.
> 
> PS2: I created the ocfs2-fix-bio_add_page.diff on 2.6.17 .
>      And later refitted the patch to 2.6.20-rc2.

Ok, great. I only looked at the 2.6.20-rc2 patch as that's what I'm running
here.


>  static int o2hb_read_slots(struct o2hb_region *reg,
>  			   unsigned int max_slots)
>  {
> -	unsigned int num_bios, slots_per_bio, start_slot, num_slots;
> -	int i, status;
> +	unsigned int current_slot=0;
> +	int status;
>  	struct o2hb_bio_wait_ctxt wc;
> -	struct bio **bios;
>  	struct bio *bio;
>  
> -	o2hb_compute_request_limits(reg, max_slots, &num_bios, &slots_per_bio);
> -
> -	bios = kcalloc(num_bios, sizeof(struct bio *), GFP_KERNEL);
> -	if (!bios) {
> -		status = -ENOMEM;
> -		mlog_errno(status);
> -		return status;
> -	}
> -
> -	o2hb_bio_wait_init(&wc, num_bios);
> -
> -	num_slots = slots_per_bio;
> -	for(i = 0; i < num_bios; i++) {
> -		start_slot = i * slots_per_bio;
> +	o2hb_bio_wait_init(&wc);
>  
> -		/* adjust num_slots at last bio */
> -		if (max_slots < (start_slot + num_slots))
> -			num_slots = max_slots - start_slot;
> -
> -		bio = o2hb_setup_one_bio(reg, &wc, start_slot, num_slots);
> +	while(current_slot < max_slots) {
> +		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots);
>  		if (IS_ERR(bio)) {
> -			o2hb_bio_wait_dec(&wc, num_bios - i);
> -
>  			status = PTR_ERR(bio);
>  			mlog_errno(status);
>  			goto bail_and_wait;
>  		}
> -		bios[i] = bio;
>  
> +		atomic_inc(&wc.wc_num_reqs);
>  		submit_bio(READ, bio);
>  	}

You changed o2hb_bio_wait_init() to initialize wc_num_reqs to zero, and
instead you increment the value before each submit_bio(). This makes sense
because we now don't know how many requests will ultimately be submitted.

However, A race now exists here between the piecemeal increment of
wc_num_reqs and the completion code in o2hb_bio_wait_dec():

		if (atomic_dec_and_test(&wc->wc_num_reqs)) {
			BUG_ON(num > 0);
			complete(&wc->wc_io_complete);
		}

So, if enough bios complete before you're done submitting all your read
requests, you could trigger the completion, wc_io_complete early.

This would certainly be hard to hit, but that's never stopped a race from
occuring before :)

So, NACK until we fix that race. Otherwise the patch seems to look fine. I
can test a future version here at Oracle.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
