Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CB7C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 Nov 2021 09:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EW/eI6Fh3YD2+FKlCf47uZ9dcMDREgLgOydg/ehqNXI=;
 b=QCP9INuZzRWOPOFeTkvzcFPMhN+HzPHURHrwckl3Wnn7Ez2B0AeAJ9chWYIuBvCy+cIOwRvAEwj5
   m2trWIZkitWl1JU2vEw67wChQ4Oq5C4J4PmhK1Fan1Nu42YYBoNeg/4spFTENtoSdPnhWF3lhmwK
   I4YjWeLemb2KDxQ0KJAxCb4mDPP8HFqfeqqoXwsK0RXJb/wvWQzK0HvS5AzxDGR1cznGTv9c3QZk
   z+H0wb7D7aQasHw0PT+es5+YE/eJ3aZyHa1QSX833bBsG3HhciMBS+g4RIE2BJXoH8hmmI/gke2v
   lrU2dCfPzS0Sh8bI9pzW5esIfsMssYRJdgTs3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EW/eI6Fh3YD2+FKlCf47uZ9dcMDREgLgOydg/ehqNXI=;
 b=hJmNRKRjE4XPgUZe30wmieWSHGvN2Fdq6h/TyFzYVMeo6ONDCPHbQUCsCmN6q/03JAhLY3AU6WM+
   n+H2WtG0wIELkGXulou43uZUaLFbGEzPfR1L7D0Lhkc6KGAyaKAXSOe9XQhJKLXlAuLtvbj98Z75
   Dn3xc5uSKu+F4ZK8ETPl6JQZtEVMR6nWMvIKQqISc+ZXej52c03r46UDcklNpS1CrClVSqTAt6DK
   zbuos/3qslK/0PO9RZELvU+7whN95iFB14R3NkzDdREuB7Ka13324y2GILwR4VjMCzRJIOgYdVdu
   BvkWRthLiy3fF1fbWliA2kvgfaslpTCmKrEj6A==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211026 64bit (built Oct 26
 2021))
 with ESMTP id <0R3200MAVLY9PZD0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 24 Nov 2021 09:49:21 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=jack@suse.cz; dkim=pass header.s=susede2_rsa header.d=suse.cz;
 dkim=permerror header.s=susede2_ed25519 header.d=suse.cz; dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1637747346;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=twMSLJi3dl6PV+ZvrQLD6fxiNCqI+8+IiOyNzLqomls=;
 b=AsSjhq5UWoJxHloKmYuZMvWa9oGBfue4hStjTj62gtxvDfOAPjPRfciIvzyhYYT/brTJj8
 ij8R2kAZIUFvqMD6QnOcHfmigo/jvWBIYGMwcHmpM2xFKF08a1tSD7at/XI9gi09iiD1G0
 fNjGCCcV8c01TxYpYRSJOBqjuIubvsU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1637747346;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=twMSLJi3dl6PV+ZvrQLD6fxiNCqI+8+IiOyNzLqomls=;
 b=zCpp+oSvqqEv+CCnvQnyAl+aiBQHmm2JBPCnsf3bwPtwcrPXovFbQnJN14LhTM2NOvpTLr
 3+hSl9JsXeV7JADw==
Date: Wed, 24 Nov 2021 10:49:06 +0100
To: Luis Chamberlain <mcgrof@kernel.org>
Message-id: <20211124094906.GG8583@quack2.suse.cz>
References: <20211123202422.819032-1-mcgrof@kernel.org>
 <20211123202422.819032-5-mcgrof@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20211123202422.819032-5-mcgrof@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 spamscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 clxscore=299 bulkscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=270 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111240055
Cc: jack@suse.cz, airlied@linux.ie, benh@kernel.crashing.org,
 amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org,
 phil@philpotter.co.uk, yzaikin@google.com, joonas.lahtinen@linux.intel.com,
 keescook@chromium.org, arnd@arndb.de, intel-gfx@lists.freedesktop.org,
 jani.nikula@linux.intel.com, viro@zeniv.linux.org.uk, rodrigo.vivi@intel.com,
 nixiaoming@huawei.com, tvrtko.ursulin@linux.intel.com,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 julia.lawall@inria.fr, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 4/8] ocfs2: simplify subdirectory
 registration with register_sysctl()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: HjiapJRWuEwHHap3Zb5D3xbE5h48-eJr
X-Proofpoint-GUID: HjiapJRWuEwHHap3Zb5D3xbE5h48-eJr
Reporting-Meta:
 AAGQE3T2Cf1SfSrtNGjKpQYsRr3LJ+zbPptWs2jKbxguhVH4pcUKGjn/N00Ge2Tf
 MzkwkaegkKBfzqGZLhqm/S/nEAFkB3MM3neccgxRSEA5wqD3UbkuayFL2aJ07CVv
 75EkWRPJPqnJAZK25Yvb8yfxYUwsiWwD6L8cj0FJn9GFThkzZeGc987HhpxfctTz
 gNCWyYdrL2V6zzvecgatCupF17gVwDL7ZgmzzU34jhwy4DqMENlL9dp8k4/1f2yQ
 PDU8zHCzsNMjz/qivfx4YTk2K6M6rnAXKwJ9OiuWnieohgT7CsHIkpdtUPTDc2nb
 vSeKden9Y5Qz0St7Xm/M/oaxJ46FN/W1E5ESBuwosMhlw91v1htjkrcJO7/WbB7Y
 xnmsLnhg32StHnYlFh9A5C13CCHD0B8r/GY4a/YO8qGxIIan7cm/+afXVYIg+snL
 JXlkCSFrEAT54x98BAmOS2RhYmD/656IU7GO2loJ8wXMhEWbul4Ed9iJ2VSPL4Wy
 GTUcK4UBtcgAxxfInwpoeWyxR7i8RoyxYT5+LxEoscY=

On Tue 23-11-21 12:24:18, Luis Chamberlain wrote:
> There is no need to user boiler plate code to specify a set of base
> directories we're going to stuff sysctls under. Simplify this by using
> register_sysctl() and specifying the directory path directly.
> 
> // pycocci sysctl-subdir-register-sysctl-simplify.cocci PATH

Heh, nice example of using Coccinelle. The result looks good. Feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> 
> @c1@
> expression E1;
> identifier subdir, sysctls;
> @@
> 
> static struct ctl_table subdir[] = {
> 	{
> 		.procname = E1,
> 		.maxlen = 0,
> 		.mode = 0555,
> 		.child = sysctls,
> 	},
> 	{ }
> };
> 
> @c2@
> identifier c1.subdir;
> 
> expression E2;
> identifier base;
> @@
> 
> static struct ctl_table base[] = {
> 	{
> 		.procname = E2,
> 		.maxlen = 0,
> 		.mode = 0555,
> 		.child = subdir,
> 	},
> 	{ }
> };
> 
> @c3@
> identifier c2.base;
> identifier header;
> @@
> 
> header = register_sysctl_table(base);
> 
> @r1 depends on c1 && c2 && c3@
> expression c1.E1;
> identifier c1.subdir, c1.sysctls;
> @@
> 
> -static struct ctl_table subdir[] = {
> -	{
> -		.procname = E1,
> -		.maxlen = 0,
> -		.mode = 0555,
> -		.child = sysctls,
> -	},
> -	{ }
> -};
> 
> @r2 depends on c1 && c2 && c3@
> identifier c1.subdir;
> 
> expression c2.E2;
> identifier c2.base;
> @@
> -static struct ctl_table base[] = {
> -	{
> -		.procname = E2,
> -		.maxlen = 0,
> -		.mode = 0555,
> -		.child = subdir,
> -	},
> -	{ }
> -};
> 
> @initialize:python@
> @@
> 
> def make_my_fresh_expression(s1, s2):
>   return '"' + s1.strip('"') + "/" + s2.strip('"') + '"'
> 
> @r3 depends on c1 && c2 && c3@
> expression c1.E1;
> identifier c1.sysctls;
> expression c2.E2;
> identifier c2.base;
> identifier c3.header;
> fresh identifier E3 = script:python(E2, E1) { make_my_fresh_expression(E2, E1) };
> @@
> 
> header =
> -register_sysctl_table(base);
> +register_sysctl(E3, sysctls);
> 
> Generated-by: Coccinelle SmPL
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  fs/ocfs2/stackglue.c | 25 +------------------------
>  1 file changed, 1 insertion(+), 24 deletions(-)
> 
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 16f1bfc407f2..731558a6f27d 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -672,31 +672,8 @@ static struct ctl_table ocfs2_mod_table[] = {
>  	{ }
>  };
>  
> -static struct ctl_table ocfs2_kern_table[] = {
> -	{
> -		.procname	= "ocfs2",
> -		.data		= NULL,
> -		.maxlen		= 0,
> -		.mode		= 0555,
> -		.child		= ocfs2_mod_table
> -	},
> -	{ }
> -};
> -
> -static struct ctl_table ocfs2_root_table[] = {
> -	{
> -		.procname	= "fs",
> -		.data		= NULL,
> -		.maxlen		= 0,
> -		.mode		= 0555,
> -		.child		= ocfs2_kern_table
> -	},
> -	{ }
> -};
> -
>  static struct ctl_table_header *ocfs2_table_header;
>  
> -
>  /*
>   * Initialization
>   */
> @@ -705,7 +682,7 @@ static int __init ocfs2_stack_glue_init(void)
>  {
>  	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
>  
> -	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
> +	ocfs2_table_header = register_sysctl("fs/ocfs2", ocfs2_mod_table);
>  	if (!ocfs2_table_header) {
>  		printk(KERN_ERR
>  		       "ocfs2 stack glue: unable to register sysctl\n");
> -- 
> 2.33.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
