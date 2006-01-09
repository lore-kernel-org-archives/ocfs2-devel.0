From: Jeff Mahoney <jeffm@suse.com>
Date: Mon, 09 Jan 2006 17:34:44 -0500
Subject: [Ocfs2-devel] [PATCH] ocfs2: actually free hb set on cluster
 removal
In-Reply-To: <20060109214501.GG3313@ca-server1.us.oracle.com>
References: <20060109174235.GB25744@locomotive.unixthugs.org>
	<20060109214501.GG3313@ca-server1.us.oracle.com>
Message-ID: <43C2E504.5070203@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Mark Fasheh wrote:
> Hi,
> 
> On Mon, Jan 09, 2006 at 12:42:35PM -0500, Jeff Mahoney wrote:
>>  Since heartbeat threads are stopped when the individual heartbeat sets are
>>  removed, this just cleans up the allocation.
> Yes, it seems we're leaking memory there.
> 
>> +	o2hb_free_hb_set(cluster->cl_group.default_groups[1]);
>>  	for (i = 0; cluster->cl_group.default_groups[i]; i++) {
>>  		killme = &cluster->cl_group.default_groups[i]->cg_item;
>>  		cluster->cl_group.default_groups[i] = NULL;
> What about the for loop on the next line? Won't that try to access memory
> freed in the call to o2hb_free_hb_set(...)?                 
> 	--Mark

Hi Mark -

Apologies, my OCFS2 tree is quite a ways from the stock one. I guess I
was just overeager pushing patches out that I figured could be applied
before I started posting the bigger changes.

So, yes, of course it will end up freeing memory that will be used
immediately afterwards. In my tree, o2hb_free_hb_set calls an exit
callback and decrements some references - no memory is freed.

I had planned on waiting a bit longer to fix up one of the early
patches, but I guess now is a good a time as any to post them.

So, I'll post them shortly. :)

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDwuUELPWxlyuTD7IRAmyvAJ48v8u7OTHGxdRxwKgnr8/BiepTxQCeLt1G
iEEluYM73wpSYAnUXvjBQAY=
=sgXu
-----END PGP SIGNATURE-----
