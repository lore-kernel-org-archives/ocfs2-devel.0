From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sat, 9 Oct 2010 04:41:27 -0700
Subject: [Ocfs2-devel] [PATCH 02/22] ocfs2: Add an incompat feature flag
	OCFS2_FEATURE_INCOMPAT_CLUSTERINFO
In-Reply-To: <20101009001554.GO13876@mail.oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
	<1286496936-17072-3-git-send-email-sunil.mushran@oracle.com>
	<20101008231103.GK8031@wotan.suse.de> <4CAFA8B8.3050101@oracle.com>
	<20101009001554.GO13876@mail.oracle.com>
Message-ID: <6632EF04-C58F-4FE9-94C9-5B37A71A3FE1@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Any other changes wrt disk format. Kurt's team is testing this thing. And I would like to make the changes in one go to minimize the pain. 

On Oct 8, 2010, at 5:15 PM, Joel Becker <Joel.Becker@oracle.com> wrote:

> On Fri, Oct 08, 2010 at 04:26:48PM -0700, Sunil Mushran wrote:
>> On 10/08/2010 04:11 PM, Mark Fasheh wrote:
>>>>  /*00*/    __u8   ci_stack[OCFS2_STACK_LABEL_LEN];
>>>> -    __le32 ci_reserved;
>>>> +    union {
>>>> +        __le32 ci_reserved;
>>>> +        struct {
>>>> +            __u8 ci_reserved1;
>>>> +            __u8 ci_reserved2;
>>>> +            __u8 ci_reserved3;
>>>> +            __u8 ci_stackflags;
>>>> 
>>> Just curious, why stick ci_stackflags at the bottom of this structure?
>>> 
>>> Wouldn't putting it at the top allow us to grow the field in the future...
>>> 
>>> Otherwise the patch looks good to me.
>>> 
>> 
>> Grow stackflags? Hmm... did not think of that.
>> 
>> I don't have a good reason for putting it at the end. Well,
>> when I put it, I thought I did. Not anymore.
> 
>    Do it.  I don't know that we'll ever grow it, but having the
> field at the beginning reads better too.
> 
> Joel
> 
> -- 
> 
> "Always give your best, never get discouraged, never be petty; always
> remember, others may hate you.  Those who hate you don't win unless
> you hate them.  And then you destroy yourself."
>    - Richard M. Nixon
> 
> Joel Becker
> Consulting Software Developer
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127
