From: Mathieu Avila <mathieu.avila@seanodes.com>
Date: Thu Sep  7 03:10:48 2006
Subject: [Ocfs2-devel] cluster/heartbeat.c::compute_max_sectors is invalid.
Message-ID: <44FFEF06.5030001@seanodes.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello OCFS2 team,

The function is defined so:

static int compute_max_sectors(struct block_device *bdev)
{
    int max_pages, max_sectors, pow_two_sectors;

    struct request_queue *q;

    q = bdev_get_queue(bdev);
    max_pages = q->max_sectors >> (PAGE_SHIFT - 9);
    if (max_pages > BIO_MAX_PAGES)
        max_pages = BIO_MAX_PAGES;
    if (max_pages > q->max_phys_segments)
        max_pages = q->max_phys_segments;
    if (max_pages > q->max_hw_segments)
        max_pages = q->max_hw_segments;
    max_pages--; /* Handle I/Os that straddle a page */

    max_sectors = max_pages << (PAGE_SHIFT - 9);

    /* Why is fls() 1-based???? */
    pow_two_sectors = 1 << (fls(max_sectors) - 1);

    return pow_two_sectors;
}


One of the device i use has "q->max_sectors"=8. Therefore, max_pages 
should be 1. This is not the case, due to the :
max_pages--; /* Handle I/Os that straddle a page */
Therefore heartbeating doesn't work on my cluster, as it is defined. 
When i force pow_two_sectors to be 8, it works fine, it heartbeats and i 
can mount the device. But the problem remains with the standard code and 
i just don't understand this statement. With the normal code, it breaks 
a little later at "o2hb_setup_one_bio", because "bio_add_page" returns 
0, which is perfectly valid for the device, as specified in the 
definition of bio_add_page (fs/bio.c):
/**
* bio_add_page - attempt to add page to bio
* @bio: destination bio
* @page: page to add
* @len: vec entry length
* @offset: vec entry offset
*
* Attempt to add a page to the bio_vec maplist. This can fail for a
* number of reasons, such as the bio being full or target block
* device limitations. The target block device must allow bio's
* smaller than PAGE_SIZE, so it is always possible to add a single
* page to an empty bio.
*/

Allocating BIOs in advance by making assumptions on the behaviour of the 
device (o2hb_compute_request_limits) is a bad idea, it seems. Instead, 
it should add pages until the device refuses to add another one. With 
the current code, i don't know whether it would take time to correct 
that, however...

--
Mathieu
