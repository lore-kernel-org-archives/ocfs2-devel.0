From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 17 Aug 2010 10:31:27 -0700
Subject: [Ocfs2-devel] BUG? a racy code at
	o2hb_heartbeat_group_drop_item()
In-Reply-To: <AANLkTim-tiG_K4mF4ymEoQu6Sug9fjUvq-KNHr9G65Hh@mail.gmail.com>
References: <AANLkTim-tiG_K4mF4ymEoQu6Sug9fjUvq-KNHr9G65Hh@mail.gmail.com>
Message-ID: <4C6AC76F.2030308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 08/17/2010 05:51 AM, ?? shin hong wrote:
> Hello. I am reporting an atomic instructions usage
> which seem be racy at fs/ocfs2/cluster/heartbeat.c in Linux 2.6.35.
>
> I am reporting this issue while I read the recent code.
> Since I do not have much background, I am not certain whether it is
> correct or not.
> But I hope this report is helpful. Please examine the code.
>
> In o2hb_heartbeat_group_drop_item(),  there are following codes:
>
> 1626        if (atomic_read(&reg->hr_steady_iterations) != 0) {
> 1627                atomic_set(&reg->hr_steady_iterations, 0);
>
>
> It first checks&reg->hr_steady_iterations and then updates its value.
>
> In the case where other threads manipulate the same
> &reg->hr_steady_iterations concurrently,
> race condition might be possible.
>
> I think it would be better to guarantee consecutive executions of
> read and write by special purposed atomic operations (e.g. atomic_xchg)
>
> Please examine the issue and let me know your opinion. Thank you.
>    

This should be safe. The only thread that could be decrementing
hr_steady_iterations is stopped before this check.
