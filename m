From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 05 May 2011 15:44:50 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/dlm: Do not migrate resource to
 a node that is leaving the domain
In-Reply-To: <20110505222417.GF17822@wotan.suse.de>
References: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
	<1303859005-29529-3-git-send-email-sunil.mushran@oracle.com>
	<20110505222417.GF17822@wotan.suse.de>
Message-ID: <4DC32862.3080901@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/05/2011 03:24 PM, Mark Fasheh wrote:
> On Tue, Apr 26, 2011 at 04:03:25PM -0700, Sunil Mushran wrote:
>> -	/* ok now we're getting desperate.  pick anyone alive. */
>> +	/* Go thru the refmap */
>>   	nodenum = -1;
>>   	while (1) {
>> -		nodenum = find_next_bit(dlm->domain_map,
>> -					O2NM_MAX_NODES, nodenum+1);
>> -		mlog(0, "found %d in domain map\n", nodenum);
>> +		nodenum = find_next_bit(res->refmap, O2NM_MAX_NODES,
>> +					nodenum + 1);
>>   		if (nodenum>= O2NM_MAX_NODES)
>>   			break;
>> -		if (nodenum != dlm->node_num) {
>> -			mlog(0, "picking %d\n", nodenum);
>> -			return nodenum;
>> -		}
>> +		if (nodenum == dlm->node_num)
>> +			continue;
>> +		if (test_bit(nodenum, dlm->exit_domain_map))
>> +			continue;
>> +		if (!test_bit(lock->ml.node, dlm->domain_map))
>> +			continue;
> If the lock's owning node isn't in the domain map, we're just ignoring it? I
> guess I'm not following what the last 'if (!test_bit(lock->ml.node,
> dlm->domain_map))' line is trying to do.
> 	--Mark
>
> PS: I'm rusty on fs/ocfs2/dlm stuff as you can tell :)

oops... that's a typo. It should be nodenum. Hey, you do remember
o2dlm. ;)

That check is superfluous. As in, that nodenum should always be in
the domain_map. But we've had that check from before and I'm trying
not to rock the boat too much.
