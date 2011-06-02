From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 03 Jun 2011 00:21:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add readonly check in
	ocfs2_quota_on().
In-Reply-To: <20110602124425.GB5718@quack.suse.cz>
References: <1306916346-29510-1-git-send-email-tristan.ye@oracle.com>
	<4DE68415.3040309@oracle.com> <20110602124425.GB5718@quack.suse.cz>
Message-ID: <4DE7B87A.7010307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/02/2011 08:44 PM, Jan Kara wrote:
> On Wed 01-06-11 11:25:25, Sunil Mushran wrote:
>> looks good.
>   Yes, looks OK to me as well. Only I'd be interested what NULL pointer
> dereference happened because I don't see how it could. Tristan, do you have
> the trace?

Sure,
	StackTrace attached.
Tristan


> 
> 								Honza
> 
>> On 06/01/2011 01:19 AM, Tristan Ye wrote:
>>> Enabling quota on a readonly ocfs2 fs caused a 'NULL pointer dereference' in
>>> dquot_enable(), a very straightforward fix is to check readonly at the very
>>> beginning of ocfs2_quota_on(), which calls dquot_enable().
>>>
>>> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
>>> ---
>>>  fs/ocfs2/super.c |    4 ++++
>>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>>> index 029c4cd..3cade2a 100644
>>> --- a/fs/ocfs2/super.c
>>> +++ b/fs/ocfs2/super.c
>>> @@ -995,6 +995,10 @@ static int ocfs2_quota_on(struct super_block *sb, int type, int format_id)
>>>  	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
>>>  		return -EINVAL;
>>>
>>> +	if (ocfs2_is_hard_readonly(OCFS2_SB(sb))) {
>>> +		return -EROFS;
>>> +	}
>>> +
>>>  	return dquot_enable(sb_dqopt(sb)->files[type], type,
>>>  			    format_id, DQUOT_LIMITS_ENABLED);
>>>  }
>>

-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: dquot_enable_oops
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20110603/c97455ef/attachment.pl 
