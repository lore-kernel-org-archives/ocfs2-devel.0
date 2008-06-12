From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Jun 2008 11:42:12 -0700
Subject: [Ocfs2-devel] [RFC][PATCH 1/3] configfs: Report errors
	in	config_*_init_type_name()
In-Reply-To: <20080612152953.438035514@kerlabs.com>
References: <20080612152645.445504681@kerlabs.com>
	<20080612152953.438035514@kerlabs.com>
Message-ID: <20080612184212.GC5377@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 05:26:46PM +0200, Louis Rilling wrote:
> config_item_set_name() may fail but its error code is not checked in
> config_*init_type_name().
> 
> This patch adds the missing error checking and make config_*_init_type_name()
> report errors.

	This patch needs to modify the callers of
config_*_init_type_name(), including fs/dlm/config.c and
fs/ocfs2/cluster/nodemanager.c

Joel

> 
> Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
> ---
>  fs/configfs/item.c       |   18 ++++++++++++++----
>  include/linux/configfs.h |    8 ++++----
>  2 files changed, 18 insertions(+), 8 deletions(-)
> 
> Index: b/fs/configfs/item.c
> ===================================================================
> --- a/fs/configfs/item.c	2008-06-12 17:13:32.000000000 +0200
> +++ b/fs/configfs/item.c	2008-06-12 17:13:35.000000000 +0200
> @@ -112,22 +112,32 @@ int config_item_set_name(struct config_i
>  
>  EXPORT_SYMBOL(config_item_set_name);
>  
> -void config_item_init_type_name(struct config_item *item,
> +int config_item_init_type_name(struct config_item *item,
>  				const char *name,
>  				struct config_item_type *type)
>  {
> -	config_item_set_name(item, name);
> +	int error;
> +
> +	error = config_item_set_name(item, name);
> +	if (error)
> +		return error;
>  	item->ci_type = type;
>  	config_item_init(item);
> +	return 0;
>  }
>  EXPORT_SYMBOL(config_item_init_type_name);
>  
> -void config_group_init_type_name(struct config_group *group, const char *name,
> +int config_group_init_type_name(struct config_group *group, const char *name,
>  			 struct config_item_type *type)
>  {
> -	config_item_set_name(&group->cg_item, name);
> +	int error;
> +
> +	error = config_item_set_name(&group->cg_item, name);
> +	if (error)
> +		return error;
>  	group->cg_item.ci_type = type;
>  	config_group_init(group);
> +	return 0;
>  }
>  EXPORT_SYMBOL(config_group_init_type_name);
>  
> Index: b/include/linux/configfs.h
> ===================================================================
> --- a/include/linux/configfs.h	2008-06-12 17:13:32.000000000 +0200
> +++ b/include/linux/configfs.h	2008-06-12 17:13:35.000000000 +0200
> @@ -71,9 +71,9 @@ static inline char *config_item_name(str
>  }
>  
>  extern void config_item_init(struct config_item *);
> -extern void config_item_init_type_name(struct config_item *item,
> -				       const char *name,
> -				       struct config_item_type *type);
> +extern int config_item_init_type_name(struct config_item *item,
> +				      const char *name,
> +				      struct config_item_type *type);
>  
>  extern struct config_item * config_item_get(struct config_item *);
>  extern void config_item_put(struct config_item *);
> @@ -97,7 +97,7 @@ struct config_group {
>  };
>  
>  extern void config_group_init(struct config_group *group);
> -extern void config_group_init_type_name(struct config_group *group,
> +extern int config_group_init_type_name(struct config_group *group,
>  					const char *name,
>  					struct config_item_type *type);
>  
> 
> -- 
> Dr Louis Rilling			Kerlabs
> Skype: louis.rilling			Batiment Germanium
> Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
> http://www.kerlabs.com/			35700 Rennes
> 

-- 

 There are morethings in heaven and earth, Horatio,
 Than are dreamt of in your philosophy.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
