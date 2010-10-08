From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 08 Oct 2010 16:26:48 -0700
Subject: [Ocfs2-devel] [PATCH 02/22] ocfs2: Add an incompat feature flag
 OCFS2_FEATURE_INCOMPAT_CLUSTERINFO
In-Reply-To: <20101008231103.GK8031@wotan.suse.de>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
	<1286496936-17072-3-git-send-email-sunil.mushran@oracle.com>
	<20101008231103.GK8031@wotan.suse.de>
Message-ID: <4CAFA8B8.3050101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/08/2010 04:11 PM, Mark Fasheh wrote:
>>   /*00*/	__u8   ci_stack[OCFS2_STACK_LABEL_LEN];
>> -	__le32 ci_reserved;
>> +	union {
>> +		__le32 ci_reserved;
>> +		struct {
>> +			__u8 ci_reserved1;
>> +			__u8 ci_reserved2;
>> +			__u8 ci_reserved3;
>> +			__u8 ci_stackflags;
>>      
> Just curious, why stick ci_stackflags at the bottom of this structure?
>
> Wouldn't putting it at the top allow us to grow the field in the future...
>
> Otherwise the patch looks good to me.
>    

Grow stackflags? Hmm... did not think of that.

I don't have a good reason for putting it at the end. Well,
when I put it, I thought I did. Not anymore.

If we have to make the change, I'll have to do it asap. We have
a very short window. Let me know if you feel that the change
is a must-do.

Sunil
