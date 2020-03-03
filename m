From: Gustavo A. R. Silva <gustavo@embeddedor.com>
Date: Mon, 2 Mar 2020 20:04:49 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Replace zero-length array with
 flexible-array member
In-Reply-To: <30493b5f-752d-147f-3d64-95b1c59895ae@linux.alibaba.com>
References: <20200213160244.GA6088@embeddedor>
	<1b78acd5-2b5f-55f1-5571-73f45d3c87f7@embeddedor.com>
	<30493b5f-752d-147f-3d64-95b1c59895ae@linux.alibaba.com>
Message-ID: <da617029-2f95-2cc5-4fdc-76af63ec1048@embeddedor.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 3/2/20 19:17, Joseph Qi wrote:
> Sorry for the late replay since I've missed the original mail.
> This patch looks good to me.
> 
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 

Thanks, Joseph.
--
Gustavo

> On 2020/3/3 07:57, Gustavo A. R. Silva wrote:
>> Hi all,
>>
>> Friendly ping: Who can take this?
>>
>> Thanks
>> --
>> Gustavo
>>
>> On 2/13/20 10:02, Gustavo A. R. Silva wrote:
>>> The current codebase makes use of the zero-length array language
>>> extension to the C90 standard, but the preferred mechanism to declare
>>> variable-length types such as these ones is a flexible array member[1][2],
>>> introduced in C99:
>>>
>>> struct foo {
>>>         int stuff;
>>>         struct boo array[];
>>> };
>>>
>>> By making use of the mechanism above, we will get a compiler warning
>>> in case the flexible array does not occur last in the structure, which
>>> will help us prevent some kind of undefined behavior bugs from being
>>> inadvertently introduced[3] to the codebase from now on.
>>>
>>> Also, notice that, dynamic memory allocations won't be affected by
>>> this change:
>>>
>>> "Flexible array members have incomplete type, and so the sizeof operator
>>> may not be applied. As a quirk of the original implementation of
>>> zero-length arrays, sizeof evaluates to zero."[1]
>>>
>>> This issue was found with the help of Coccinelle.
>>>
>>> [1] https://urldefense.com/v3/__https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html__;!!GqivPVa7Brio!L0RwciXIP78A1BHW_X6fy0HxrYfZeqFYBy-b3TvW5Tm324I3fZTZo2OXDxRuEgli5H2pZw$ 
>>> [2] https://urldefense.com/v3/__https://github.com/KSPP/linux/issues/21__;!!GqivPVa7Brio!L0RwciXIP78A1BHW_X6fy0HxrYfZeqFYBy-b3TvW5Tm324I3fZTZo2OXDxRuEgmW0y7Pgw$ 
>>> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>>>
>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>> ---
>>>  fs/ocfs2/journal.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>>> index 68ba354cf361..b425f0b01dce 100644
>>> --- a/fs/ocfs2/journal.c
>>> +++ b/fs/ocfs2/journal.c
>>> @@ -91,7 +91,7 @@ enum ocfs2_replay_state {
>>>  struct ocfs2_replay_map {
>>>  	unsigned int rm_slots;
>>>  	enum ocfs2_replay_state rm_state;
>>> -	unsigned char rm_replay_slots[0];
>>> +	unsigned char rm_replay_slots[];
>>>  };
>>>  
>>>  static void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
>>>
