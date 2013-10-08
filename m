From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 08 Oct 2013 09:46:14 -0500
Subject: [Ocfs2-devel] [PATCH 3/7] Differentiate between no_controld and
 with_controld
In-Reply-To: <20131008004335.GL5358@localhost>
References: <20130927170748.GA11716@shrek.lan>
	<20130927190232.GD26517@localhost> <5246EA2E.3090405@suse.de>
	<20131008000054.GJ5358@localhost> <52534F2A.6060901@suse.de>
	<20131008004335.GL5358@localhost>
Message-ID: <52541AB6.4000004@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/07/2013 07:43 PM, Joel Becker wrote:
> On Mon, Oct 07, 2013 at 07:17:46PM -0500, Goldwyn Rodrigues wrote:
>> On 10/07/2013 07:00 PM, Joel Becker wrote:
>>> On Sat, Sep 28, 2013 at 09:39:42AM -0500, Goldwyn Rodrigues wrote:
>>>> On 09/27/2013 02:02 PM, Joel Becker wrote:
>>>>> On Fri, Sep 27, 2013 at 12:07:53PM -0500, Goldwyn Rodrigues wrote:
>>>>>> -	/*
>>>>>> -	 * running_proto must have been set before we allowed any mounts
>>>>>> -	 * to proceed.
>>>>>> -	 */
>>>>>> -	if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
>>>>>> -		printk(KERN_ERR
>>>>>> -		       "Unable to mount with fs locking protocol version "
>>>>>> -		       "%u.%u because the userspace control daemon has "
>>>>>> -		       "negotiated %u.%u\n",
>>>>>> -		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
>>>>>> -		       running_proto.pv_major, running_proto.pv_minor);
>>>>>> -		rc = -EPROTO;
>>>>>> -		user_cluster_disconnect(conn);
>>>>>> -		goto out;
>>>>>> +	if (type == WITH_CONTROLD) {
>>>>>> +		/*
>>>>>> +		 * running_proto must have been set before we allowed any mounts
>>>>>> +		 * to proceed.
>>>>>> +		 */
>>>>>> +		if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
>>>>>
>>>>> You need to find a way to compare the fs locking protocol in the new
>>>>> style.  Otherwise the two ocfs2 versions can't be sure they are using
>>>>> the same locks in the same way.
>>>>>
>>>>
>>>> What locking protocol is it safeguarding? Is it something to do
>>>> specifically with the OCFS2 fs, or with respect to controld set
>>>> versioning only?
>>>
>>> Specific to ocfs2.  Think about it this way.  Both nodes might have the
>>> exact same version of fs/dlm, but node1 has an ocfs2 version using EX
>>> locks for an operation, while node2 has a new version of ocfs2 that can
>>> use PR locks for the same thing.  The two cannot interact safely.  By
>>> checking the protocol, the newer version knows to use the EX lock.
>>
>> What happens if a lower version ocfs2 node has mounted the ocfs2
>> partition and the higher version node attempts to mount the
>> partition? though it's obvious, I would like to know the vice-versa
>> case as well.
>
> This is explicitly documented in the version comparison code
> (fs_protocol_compare()):
>
>    1. If the major numbers are different, they are incompatible.
>    2. If the current minor is greater than the request, they are
>       incompatible.
>    3. If the current minor is less than or equal to the request, they are
>       compatible, and the requester should run at the current minor
>       version.
>
> Specific examples:
>
> - If a node is the first node in the cluster, it will set the running
>    version to its major.minor.
> - If a node joins a cluster already running at 1.2, and the new node has
>    a version of 2.0, it will fail to mount (incompatible major version).
> - If a node joins a cluster already running at 1.2, and the new node has
>    a version of 1.1, it will fail to mount (incompatible minor version).
> - If a node joins a cluster already running at 1.2, and the new node has
>    a version of 1.3, it will mount at version 1.2 (matching the running
>    minor version).
>
>> I am thinking in terms of keeping the ocfs2 lock version on disk as
>> a system file with each node PR locking and reading the file. The
>> first mount writes it with an EX lock. Of course, we cannot afford
>> to change this part of the locking in the future. Would that be a
>> feasible solution? This may require version upgrade.
>
> No.  It should not be on disk, and it must not be permanent.  Consider a
> cluster running at version 1.2.  One by one, each node is upgraded to a
> new version of ocfs2 that supports the 1.3 protocol. Each node will
> still reconnect to the cluster at 1.2 due to the third rule above.  But
> when the entire cluster is taken down for maintenance, they will start
> back up at 1.3.  In the future, we may even support online update to the
> new version when every node has it.

Yes, the method I proposed works with what you mentioned and it is not 
permanent. Let me elaborate on what I said. A node on mount after 
setting up DLM would:

Requests a non-blocking EX lock on the protocol version file.
   If it fails, it takes a PR lock on the version file.
   If it succeeds, it writes it's own version info *overwriting* what 
was before and downconverts to PR lock. ie, even if there is a higher 
version in the file before.

This could be done with existing inode locks and no other locking 
infrastructure needs to be added.

This way if the first node is 1.2, the whole cluster will be 1.2 even if 
a node with 1.3 joins. The first node decides what the entire cluster 
will be. Later, if all nodes have upgraded to 1.3, and the whole cluster 
restarts after a total cluster shutdown, the whole cluster will start 
with 1.3

The reason I proposed a file is because this is ocfs2 specific, and 
ideally should not be mixed with dlm stuff.

>
> A far more reasonable solution would be to create a special lock in the
> DLM that has the version number in the LVB.  You will, of course, have
> to handle LVB recovery.
>

If the above proposal works, we don't need to bother with recovery. It 
becomes DLM's responsibility. We could extend it to perform online 
locking version update, but it requires much more work from the locking POV.


-- 
Goldwyn
