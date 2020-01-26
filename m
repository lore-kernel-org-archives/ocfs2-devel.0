From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sun, 26 Jan 2020 10:21:21 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] lockres_seq_next should increase
	position index
In-Reply-To: <ca1497b7-6a6e-8043-63c7-b17c094ebc05@virtuozzo.com>
References: <ca1497b7-6a6e-8043-63c7-b17c094ebc05@virtuozzo.com>
Message-ID: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 20/1/23 15:39, Vasily Averin wrote:
> if seq_file .next fuction does not change position index,
> read after some lseek can generate unexpected output.
> 
> https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D206283&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=lFWWo4w3KGQSd5EANoUFCp9aybqo1xeFs5MD0dgTnkA&s=dFZ-8He72Ffi8NGZB7iFik1nYOMs9wfzjDFpATCr72I&e= 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

We'd better add the missing tag:

Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")

> ---
>  fs/ocfs2/dlm/dlmdebug.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index 4d0b452..08a19c9 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -590,6 +590,7 @@ static void lockres_seq_stop(struct seq_file *m, void *v)
>  
>  static void *lockres_seq_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> +	(*pos)++;
>  	return NULL;
>  }
>  
> 
