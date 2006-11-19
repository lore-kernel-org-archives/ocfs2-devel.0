From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sun Nov 19 19:47:29 2006
Subject: [Ocfs2-devel] [patch 2/3] OCFS2 Configurable timeouts
In-Reply-To: <20061118073632.559447000@suse.de>
References: <20061118073600.206222000@suse.de>
	<20061118073632.559447000@suse.de>
Message-ID: <20061120034725.GB30647@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,
	Thanks for sending these out. Your first patch looks fine. My
comments for this one are inlined below.

On Sat, Nov 18, 2006 at 08:36:02AM +0100, abeekhof@suse.de wrote:
> +static ssize_t o2nm_cluster_attr_idle_timeout_ms_read(struct o2nm_cluster *cluster,
> +                                                 char *page)
> +{
> +	return sprintf(page, "%u\n", cluster->cl_idle_timeout_ms);
> +}
> +
> +static ssize_t o2nm_cluster_attr_idle_timeout_ms_write(struct o2nm_cluster *cluster,
> +                                                  const char *page,
> +						  size_t count)
> +{
> +	ssize_t ret;
> +	unsigned int val;
> +
> +	ret =  o2nm_cluster_attr_write(page, count, &val);
> +
> +	if (ret > 0) {
> +		if (val <= cluster->cl_keepalive_delay_ms) {
> +			mlog(ML_NOTICE, "o2net: idle timeout must be larger "
> +			     "than keepalive delay\n");
> +			return -EINVAL;
> +		}
> +		cluster->cl_idle_timeout_ms = val;
> +	}
> +
> +	return ret;
> +}
> +
> +static ssize_t o2nm_cluster_attr_keepalive_delay_ms_read(struct o2nm_cluster *cluster,
> +                                                 char *page)
> +{
> +	return sprintf(page, "%u\n", cluster->cl_keepalive_delay_ms);
> +}
> +
> +static ssize_t o2nm_cluster_attr_keepalive_delay_ms_write(struct o2nm_cluster *cluster,
> +                                                  const char *page,
> +						  size_t count)
> +{
> +	ssize_t ret;
> +	unsigned int val;
> +
> +	ret =  o2nm_cluster_attr_write(page, count, &val);
> +
> +	if (ret > 0) {
> +		if (val >= cluster->cl_idle_timeout_ms) {
> +			mlog(ML_NOTICE, "o2net: keepalive delay must be "
> +			     "smaller than idle timeout\n");
> +			return -EINVAL;
> +		}
> +		cluster->cl_keepalive_delay_ms = val;
> +	}
> +
> +	return ret;
> +}
Is it safe for us to allow the keepalive delay and the idle timeout values
to change while the cluster is up? The next patch should be checking that
the values are the same on all nodes, but if we can change it mid stream,
what's the point?


> Index: fs/ocfs2/cluster/tcp.c
> ===================================================================
> --- fs/ocfs2/cluster/tcp.c.orig	2006-11-15 11:58:34.000000000 +0100
> +++ fs/ocfs2/cluster/tcp.c	2006-11-15 12:06:24.000000000 +0100
> @@ -147,6 +147,28 @@ static void o2net_listen_data_ready(stru
>  static void o2net_sc_send_keep_req(void *arg);
>  static void o2net_idle_timer(unsigned long data);
>  static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
> +static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
> +
> +/*
> + * FIXME: These should use to_o2nm_cluster_from_node(), but we end up
> + * losing our parent link to the cluster during shutdown. This can be
> + * solved by adding a pre-removal callback to configfs, or passing
> + * around the cluster with the node. -jeffm
> + */
> +static inline int o2net_reconnect_delay(struct o2nm_node *node)
> +{
> +	return o2nm_single_cluster->cl_reconnect_delay_ms;
> +}
This patch exists now - it's in ocfs2.git:

http://kernel.org/git/?p=linux/kernel/git/mfasheh/ocfs2.git;a=commit;h=e47575895914402e1e72f00b3db539f468b849e3

You can probably just add a patch on top of all these to fix that to use
the new callback.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
