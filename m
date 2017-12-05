From: alex chen <alex.chen@huawei.com>
Date: Tue, 5 Dec 2017 15:58:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: neaten a member of
	o2net_msg_handler
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F1F554DA@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373F1F554DA@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <5A2651B0.5070001@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

Thank you for your patch.

On 2017/12/5 13:47, Changwei Ge wrote:
> It's odd that o2net_msg_handler::nh_func_data is declared as type
> o2net_msg_handler_func*.
> So neaten it.
> 
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
> ---
>   fs/ocfs2/cluster/tcp_internal.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/tcp_internal.h 
> b/fs/ocfs2/cluster/tcp_internal.h
> index b95e7df5b76a..0276f7f8d5e6 100644
> --- a/fs/ocfs2/cluster/tcp_internal.h
> +++ b/fs/ocfs2/cluster/tcp_internal.h
> @@ -196,7 +196,7 @@ struct o2net_msg_handler {
>   	u32			nh_msg_type;
>   	u32			nh_key;
>   	o2net_msg_handler_func	*nh_func;
> -	o2net_msg_handler_func	*nh_func_data;
> +	void			*nh_func_data;
>   	o2net_post_msg_handler_func
>   				*nh_post_func;
>   	struct kref		nh_kref;
> 
