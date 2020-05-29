From: Xiaoming Ni <nixiaoming@huawei.com>
Date: Fri, 29 May 2020 20:09:01 +0800
Subject: [Ocfs2-devel] [PATCH 11/13] random: simplify sysctl declaration
 with register_sysctl_subdir()
In-Reply-To: <20200529102644.GB1345939@kroah.com>
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-12-mcgrof@kernel.org>
	<20200529102644.GB1345939@kroah.com>
Message-ID: <289b2d65-bf28-1246-7f4f-2411e3f27e16@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>, Luis Chamberlain <mcgrof@kernel.org>
Cc: jack@suse.cz, rafael@kernel.org, airlied@linux.ie, benh@kernel.crashing.org, amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org, joseph.qi@linux.alibaba.com, sfr@canb.auug.org.au, mark@fasheh.com, rdna@fb.com, yzaikin@google.com, keescook@chromium.org, arnd@arndb.de, intel-gfx@lists.freedesktop.org, julia.lawall@lip6.fr, jlbec@evilplan.org, vbabka@suse.cz, axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org, ebiederm@xmission.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On 2020/5/29 18:26, Greg KH wrote:
> On Fri, May 29, 2020 at 07:41:06AM +0000, Luis Chamberlain wrote:
>> From: Xiaoming Ni <nixiaoming@huawei.com>
>>
>> Move random_table sysctl from kernel/sysctl.c to drivers/char/random.c
>> and use register_sysctl_subdir() to help remove the clutter out of
>> kernel/sysctl.c.
>>
>> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>> ---
>>   drivers/char/random.c  | 14 ++++++++++++--
>>   include/linux/sysctl.h |  1 -
>>   kernel/sysctl.c        |  5 -----
>>   3 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/char/random.c b/drivers/char/random.c
>> index a7cf6aa65908..73fd4b6e9c18 100644
>> --- a/drivers/char/random.c
>> +++ b/drivers/char/random.c
>> @@ -2101,8 +2101,7 @@ static int proc_do_entropy(struct ctl_table *table, int write,
>>   }
>>   
>>   static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
>> -extern struct ctl_table random_table[];
>> -struct ctl_table random_table[] = {
>> +static struct ctl_table random_table[] = {
>>   	{
>>   		.procname	= "poolsize",
>>   		.data		= &sysctl_poolsize,
>> @@ -2164,6 +2163,17 @@ struct ctl_table random_table[] = {
>>   #endif
>>   	{ }
>>   };
>> +
>> +/*
>> + * rand_initialize() is called before sysctl_init(),
>> + * so we cannot call register_sysctl_init() in rand_initialize()
>> + */
>> +static int __init random_sysctls_init(void)
>> +{
>> +	register_sysctl_subdir("kernel", "random", random_table);
> 
> No error checking?
> 
> :(
It was my mistake, I forgot to add a comment here.
Same as the comment of register_sysctl_init(),
There is almost no failure here during the system initialization phase,
and failure in time does not affect the main function.

Thanks
Xiaoming Ni
