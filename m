From: Gang He <ghe@suse.com>
Date: Wed, 12 Jun 2019 21:36:45 -0600
Subject: [Ocfs2-devel] mmotm 2019-06-11-16-59 uploaded (ocfs2)
In-Reply-To: <20190612181813.48ad05832e05f767e7116d7b@linux-foundation.org>
References: <20190611235956.4FZF6%akpm@linux-foundation.org>
	<492b4bcc-4760-7cbb-7083-9f22e7ab4b82@infradead.org>
	<20190612181813.48ad05832e05f767e7116d7b@linux-foundation.org>
Message-ID: <5D01C4CD020000F90006C06A@prv1-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org
Cc: sfr@canb.auug.org.au, broonie@kernel.org, linux-mm@kvack.org, Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com, mhocko@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, mm-commits@vger.kernel.org

Hello Randy and Andrew,

>>> On 6/13/2019 at  9:18 am, in message
<20190612181813.48ad05832e05f767e7116d7b@linux-foundation.org>, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 12 Jun 2019 07:15:30 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> On 6/11/19 4:59 PM, akpm at linux-foundation.org wrote:
>> > The mm-of-the-moment snapshot 2019-06-11-16-59 has been uploaded to
>> > 
>> >    
> https://urldefense.proofpoint.com/v2/url?u=http-3A__www.ozlabs.org_-7Eakpm_ 
> mmotm_&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0
> vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=zWoF0Bft4OzQeAaZXMGI56DN7p9MjLynOay4PZYAlhQ&s=vYme
> DBOk3Nv08-ZA7IweIdaUk094Ldvmgzc20fjjzDs&e=
>> > 
>> > mmotm-readme.txt says
>> > 
>> > README for mm-of-the-moment:
>> > 
>> > 
> https://urldefense.proofpoint.com/v2/url?u=http-3A__www.ozlabs.org_-7Eakpm_mmo 
> tm_&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU
> 6X8CMk6L2iDY8-HD0qT6Fo7Y&m=zWoF0Bft4OzQeAaZXMGI56DN7p9MjLynOay4PZYAlhQ&s=vYmeDBO
> k3Nv08-ZA7IweIdaUk094Ldvmgzc20fjjzDs&e=
>> > 
>> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
>> > more than once a week.
>> 
>> 
>> on i386:
>> 
>> ld: fs/ocfs2/dlmglue.o: in function `ocfs2_dlm_seq_show':
>> dlmglue.c:(.text+0x46e4): undefined reference to `__udivdi3'
> 
> Thanks.  This, I guess:
> 
> --- a/fs/ocfs2/dlmglue.c~ocfs2-add-locking-filter-debugfs-file-fix
> +++ a/fs/ocfs2/dlmglue.c
> @@ -3115,7 +3115,7 @@ static int ocfs2_dlm_seq_show(struct seq
>  		 * otherwise, only dump the last N seconds active lock
>  		 * resources.
>  		 */
> -		if ((now - last) / 1000000 > dlm_debug->d_filter_secs)
> +		if (div_u64(now - last, 1000000) > dlm_debug->d_filter_secs)
>  			return 0;
>  	}
>  #endif
> 
> review and test, please?
Thank for this fix, the change is OK for my testing on x86_64.

Thanks
Gang

> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
