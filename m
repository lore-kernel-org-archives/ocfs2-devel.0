From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Tue, 23 Dec 2014 12:14:44 +0100
Subject: [Ocfs2-devel] [PATCH 1/1 linux-next] ocfs2: remove unnecessary
	sizeof(char)
In-Reply-To: <20141222133501.916a0944e5f0719e60e2c4eb@linux-foundation.org>
	(Andrew Morton's message of "Mon, 22 Dec 2014 13:35:01 -0800")
References: <1419275109-11641-1-git-send-email-fabf@skynet.be>
	<20141222133501.916a0944e5f0719e60e2c4eb@linux-foundation.org>
Message-ID: <87k31ibot7.fsf@rasmusvillemoes.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org, joe@perches.com, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>

On Mon, Dec 22 2014, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 22 Dec 2014 20:05:09 +0100 Fabian Frederick <fabf@skynet.be> wrote:
>
>>  
>> -	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) +
>> -			     (osb->max_slots * sizeof(char)), GFP_KERNEL);
>> +	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) + osb->max_slots,
>> +			     GFP_KERNEL);
>>  
>
> I dunno.  The code at present isn't particularly idiomatic, but it has
> some documentation value and says "I know what I'm doing".
>
> It would be better if it was
>
> 	kzalloc(sizeof(struct ocfs2_replay_map) *
> 		sizeof(struct ocfs2_replay_map.rm_replay_slots[0]), ...);
>
> And it would be better if C permitted that ;)
>
> 	kzalloc(sizeof(struct ocfs2_replay_map) *
> 		sizeof((struct ocfs2_replay_map *)0)->rm_replay_slots[0]), ...);
>
> yuk.

Well, the yuckiness could be hidden behind FIELD_SIZEOF. CodingStyle
explicitly mentions that macro. No opinion on whether it's worth it in
this case.

Rasmus
