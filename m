From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 3 Mar 2020 09:17:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Replace zero-length array with
 flexible-array member
In-Reply-To: <1b78acd5-2b5f-55f1-5571-73f45d3c87f7@embeddedor.com>
References: <20200213160244.GA6088@embeddedor>
	<1b78acd5-2b5f-55f1-5571-73f45d3c87f7@embeddedor.com>
Message-ID: <30493b5f-752d-147f-3d64-95b1c59895ae@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Sorry for the late replay since I've missed the original mail.
This patch looks good to me.

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

On 2020/3/3 07:57, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: Who can take this?
> 
> Thanks
> --
> Gustavo
> 
> On 2/13/20 10:02, Gustavo A. R. Silva wrote:
>> The current codebase makes use of the zero-length array language
>> extension to the C90 standard, but the preferred mechanism to declare
>> variable-length types such as these ones is a flexible array member[1][2],
>> introduced in C99:
>>
>> struct foo {
>>         int stuff;
>>         struct boo array[];
>> };
>>
>> By making use of the mechanism above, we will get a compiler warning
>> in case the flexible array does not occur last in the structure, which
>> will help us prevent some kind of undefined behavior bugs from being
>> inadvertently introduced[3] to the codebase from now on.
>>
>> Also, notice that, dynamic memory allocations won't be affected by
>> this change:
>>
>> "Flexible array members have incomplete type, and so the sizeof operator
>> may not be applied. As a quirk of the original implementation of
>> zero-length arrays, sizeof evaluates to zero."[1]
>>
>> This issue was found with the help of Coccinelle.
>>
>> [1] https://urldefense.com/v3/__https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html__;!!GqivPVa7Brio!IqIf1kXINaofUdjTQKfUAjzgxIXeGsrvqMv7P5eK_l094j-wNPLRzzZ6U0LKmQmDvBq4SA$ 
>> [2] https://urldefense.com/v3/__https://github.com/KSPP/linux/issues/21__;!!GqivPVa7Brio!IqIf1kXINaofUdjTQKfUAjzgxIXeGsrvqMv7P5eK_l094j-wNPLRzzZ6U0LKmQmeutI_Bg$ 
>> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>  fs/ocfs2/journal.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index 68ba354cf361..b425f0b01dce 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -91,7 +91,7 @@ enum ocfs2_replay_state {
>>  struct ocfs2_replay_map {
>>  	unsigned int rm_slots;
>>  	enum ocfs2_replay_state rm_state;
>> -	unsigned char rm_replay_slots[0];
>> +	unsigned char rm_replay_slots[];
>>  };
>>  
>>  static void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
>>
