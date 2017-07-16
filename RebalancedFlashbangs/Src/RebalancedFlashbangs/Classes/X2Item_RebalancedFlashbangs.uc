class X2Item_RebalancedFlashbangs extends X2Item_DefaultGrenades config(RebalancedFlashbangs);


var config WeaponDamageValue BETTERFLASHBANGGRENADE_BASEDAMAGE;
var config int BETTERFLASHBANGGRENADE_ISOUNDRANGE;
var config int BETTERFLASHBANGGRENADE_IENVIRONMENTDAMAGE;
var config int BETTERFLASHBANGGRENADE_ISUPPLIES;
var config int BETTERFLASHBANGGRENADE_TRADINGPOSTVALUE;
var config int BETTERFLASHBANGGRENADE_IPOINTS;
var config int BETTERFLASHBANGGRENADE_ICLIPSIZE;
var config int BETTERFLASHBANGGRENADE_RANGE;
var config int BETTERFLASHBANGGRENADE_RADIUS;
var config int BETTERFLASHBANGGRENADE_STUNCHANCE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Grenades;
	
	Grenades.AddItem(CreateFlashbangGrenade());

	return Grenades;
}


static function X2DataTemplate CreateFlashbangGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'FlashbangGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons..Inv_Flashbang_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.iRange = default.BETTERFLASHBANGGRENADE_RANGE;
	Template.iRadius = default.BETTERFLASHBANGGRENADE_RADIUS;
	
	Template.BaseDamage = default.BETTERFLASHBANGGRENADE_BASEDAMAGE;

	Template.bFriendlyFire = true;
	Template.bFriendlyFireWarning = true;
	Template.Abilities.AddItem('ThrowGrenade');

	// TODO: Figure out how to truly check for a random chance here. Check out stat contests
	/*
	if (`SYNC_RAND_STATIC(100) < 25)
	{
		Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100));
	}
	else 
	{
	    Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects_Rebalanced'.static.CreateBetterDisorientedStatusEffect(false, 0.0f, 100));
	}
	*/

	// 25% to additionally apply the Stunned debuff - workaround
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect());
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 25));

	//We need to have an ApplyWeaponDamage for visualization, even if the grenade does 0 damage (makes the unit flinch, shows overwatch removal)
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Flashbang.WP_Grenade_Flashbang";

	Template.StartingItem = true;
	Template.CanBeBuilt = false;

	Template.iSoundRange = default.BETTERFLASHBANGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.BETTERFLASHBANGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = default.BETTERFLASHBANGGRENADE_TRADINGPOSTVALUE;
	Template.PointsToComplete = default.BETTERFLASHBANGGRENADE_IPOINTS;
	Template.iClipSize = default.BETTERFLASHBANGGRENADE_ICLIPSIZE;
	Template.Tier = 0;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 35;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.HideIfResearched = 'AdvancedGrenades';

	// Soldier Bark
	Template.OnThrowBarkSoundCue = 'ThrowFlashbang';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.BETTERFLASHBANGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.BETTERFLASHBANGGRENADE_RADIUS);

	return Template;
}
