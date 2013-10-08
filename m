From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Mon, 07 Oct 2013 19:17:46 -0500
Subject: [Ocfs2-devel] [PATCH 3/7] Differentiate between no_controld and
 with_controld
In-Reply-To: <20131008000054.GJ5358@localhost>
References: <20130927170748.GA11716@shrek.lan>
	<20130927190232.GD26517@localhost> <5246EA2E.3090405@suse.de>
	<20131008000054.GJ5358@localhost>
Message-ID: <52534F2A.6060901@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Thanks for the comments.

On 10/07/2013 07:00 PM, Joel Becker wrote:
> On Sat, Sep 28, 2013 at 09:39:42AM -0500, Goldwyn Rodrigues wrote:
>> On 09/27/2013 02:02 PM, Joel Becker wrote:
>>> On Fri, Sep 27, 2013 at 12:07:53PM -0500, Goldwyn Rodrigues wrote:
>>>> -	/*
>>>> -	 * running_proto must have been set before we allowed any mounts
>>>> -	 * to proceed.
>>>> -	 */
>>>> -	if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
>>>> -		printk(KERN_ERR
>>>> -		       "Unable to mount with fs locking protocol version "
>>>> -		       "%u.%u because the userspace control daemon has "
>>>> -		       "negotiated %u.%u\n",
>>>> -		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
>>>> -		       running_proto.pv_major, running_proto.pv_minor);
>>>> -		rc = -EPROTO;
>>>> -		user_cluster_disconnect(conn);
>>>> -		goto out;
>>>> +	if (type == WITH_CONTROLD) {
>>>> +		/*
>>>> +		 * running_proto must have been set before we allowed any mounts
>>>> +		 * to proceed.
>>>> +		 */
>>>> +		if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
>>>
>>> You need to find a way to compare the fs locking protocol in the new
>>> style.  Otherwise the two ocfs2 versions can't be sure they are using
>>> the same locks in the same way.
>>>
>>
>> What locking protocol is it safeguarding? Is it something to do
>> specifically with the OCFS2 fs, or with respect to controld set
>> versioning only?
>
> Specific to ocfs2.  Think about it this way.  Both nodes might have the
> exact same version of fs/dlm, but node1 has an ocfs2 version using EX
> locks for an operation, while node2 has a new version of ocfs2 that can
> use PR locks for the same thing.  The two cannot interact safely.  By
> checking the protocol, the newer version knows to use the EX lock.

What happens if a lower version ocfs2 node has mounted the ocfs2 
partition and the higher version node attempts to mount the partition? 
though it's obvious, I would like to know the vice-versa case as well.

I am thinking in terms of keeping the ocfs2 lock version on disk as a 
system file with each node PR locking and reading the file. The first 
mount writes it with an EX lock. Of course, we cannot afford to change 
this part of the locking in the future. Would that be a feasible 
solution? This may require version upgrade.

>
>> The advantage of eliminating controld is that all inter-node
>> communication is handled by fs/dlm. This includes protocol
>> negotiation.
>
> 	This isn't about controld here, it's about the way the
> filesystem uses locking.  Similarly, o2cb/o2dlm has a version for the
> network/dlm protocol that is distinct from the fs protocol.
> 	A new mechanism without controld will need another way to
> communicate the fs protocol version.  This will require a new major
> version for that as well.
>
>> Unfortunately, dlm with fs-controld (v3) is not compatible dlm
>> without fs-controld (v4). I think they call different numbers for
>> protocol versioning (v5/v6). So, all nodes will have to be upgraded
>> anyways with cluster downtime.
>
> Sure, but once you're on the new controld, you should still be able to
> upgrade your ocfs2 software without downtime.
>
> Joel
>


-- 
Goldwyn
