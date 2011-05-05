From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 05 May 2011 15:15:34 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/dlm:
 dlm_is_lockres_migrateable() returns boolean
In-Reply-To: <20110505220930.GD17822@wotan.suse.de>
References: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
	<20110505220930.GD17822@wotan.suse.de>
Message-ID: <4DC32186.7000200@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/05/2011 03:09 PM, Mark Fasheh wrote:
> On Tue, Apr 26, 2011 at 04:03:23PM -0700, Sunil Mushran wrote:
>>
>> -	*numlocks = count;
>> -
>> -	count = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
>> -	if (count<  O2NM_MAX_NODES)
>> -		*hasrefs = 1;
>> +	if (!nonlocal) {
>> +		nonlocal = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
>> +		if (nonlocal>= O2NM_MAX_NODES)
>> +			return 0;
> Minor quibble, but can you use a new variable for these two lines? It took
> me a minute to realize that what you were doing was gettting a refcount on
> the lockres. Maybe:
>
> if (!nonlocal) {
> 	/*
> 	 * We have no locks on the resource (local or remote). Check for
> 	 * references now.
> 	 */
> 	node_ref = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
> 	if (node_ref>= O2NM_MAX_NODES)
> 		return 0;
> 	}
> }

ok.
